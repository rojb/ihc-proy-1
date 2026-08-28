import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { EventStatus, Prisma, type Event } from '@prisma/client';
import {
  DEFAULT_EVENT_DURATION_HOURS,
  RECENTLY_UPDATED_WINDOW_HOURS,
} from '../common/constants';
import { distanceInKm } from '../common/geo';
import { endOfDayInBolivia, weekendRangeInBolivia } from '../common/time';
import { PrismaService } from '../prisma/prisma.service';
import { CreateEventDto } from './dto/create-event.dto';
import { ListEventsQueryDto } from './dto/list-events.query.dto';
import { UpdateEventDto } from './dto/update-event.dto';

const MS_PER_HOUR = 3_600_000;

/**
 * FR-03 · Los tres estados de vigencia que la tarjeta tiene que poder mostrar.
 * No hay un cuarto estado "vencido": un evento que terminó sale de la lista
 * (FR-01), no cambia de etiqueta.
 */
export type Validity = 'VIGENTE' | 'ACTUALIZADO_RECIENTE' | 'CANCELADO';

/** Fila de Prisma con el conteo de interes y, si hay dispositivo, su marca. */
type EventRow = Event & {
  _count: { interests: number };
  interests?: { id: string }[];
};

export interface EventDto {
  id: string;
  name: string;
  description: string | null;
  startsAt: string;
  endsAt: string | null;
  priceCents: number;
  currency: string;
  isFree: boolean;
  locationName: string;
  reference: string | null;
  zone: string;
  latitude: number | null;
  longitude: number | null;
  imageUrl: string | null;
  validity: Validity;
  lastEditedAt: string | null;
  interestCount: number;
  interested: boolean;
  distanceKm: number | null;
}

/** El fin real del evento: el cargado, o el inicio mas la duracion por defecto. */
export function effectiveEndOf(event: Pick<Event, 'startsAt' | 'endsAt'>): Date {
  return (
    event.endsAt ??
    new Date(
      event.startsAt.getTime() + DEFAULT_EVENT_DURATION_HOURS * MS_PER_HOUR,
    )
  );
}

/**
 * FR-03 · Cancelado gana sobre cualquier otro estado: es la informacion que
 * evita que alguien comparta al grupo un evento que ya no existe (JTBD-3).
 */
export function resolveValidity(
  event: Pick<Event, 'status' | 'lastEditedAt'>,
  now: Date = new Date(),
): Validity {
  if (event.status === EventStatus.CANCELLED) {
    return 'CANCELADO';
  }

  if (
    event.lastEditedAt &&
    now.getTime() - event.lastEditedAt.getTime() <=
      RECENTLY_UPDATED_WINDOW_HOURS * MS_PER_HOUR
  ) {
    return 'ACTUALIZADO_RECIENTE';
  }

  return 'VIGENTE';
}

@Injectable()
export class EventsService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * FR-01 · Lista de vigentes, orden fecha ascendente y luego cercania.
   * Los cancelados siguen apareciendo marcados hasta que su fecha pasa: FR-03
   * es explicito en que un evento cancelado no desaparece en silencio.
   */
  async list(
    query: ListEventsQueryDto,
    deviceId?: string,
  ): Promise<{ count: number; items: EventDto[] }> {
    const now = new Date();
    const conditions: Prisma.EventWhereInput[] = [this.notFinishedYet(now)];

    if (query.when === 'today') {
      conditions.push({ startsAt: { lte: endOfDayInBolivia(now) } });
    } else if (query.when === 'weekend') {
      const { from, to } = weekendRangeInBolivia(now);
      conditions.push({ startsAt: { gte: from, lte: to } });
    }

    if (query.maxPriceCents !== undefined) {
      conditions.push({ priceCents: { lte: query.maxPriceCents } });
    }

    if (query.zone) {
      conditions.push({ zone: query.zone });
    }

    const rows = (await this.prisma.event.findMany({
      where: { AND: conditions },
      orderBy: { startsAt: 'asc' },
      include: this.includeFor(deviceId),
    })) as EventRow[];

    const origin = this.originOf(query);
    let items = rows.map((row) => this.toDto(row, now, origin));

    if (origin && query.radiusKm !== undefined) {
      const radius = query.radiusKm;
      // Un evento sin coordenadas no se puede evaluar contra un radio. Se
      // excluye en vez de colarse: FR-04 promete que el numero de resultados
      // refleja el filtro aplicado.
      items = items.filter(
        (item) => item.distanceKm !== null && item.distanceKm <= radius,
      );
    }

    items.sort((a, b) => {
      const byDate = Date.parse(a.startsAt) - Date.parse(b.startsAt);
      if (byDate !== 0) {
        return byDate;
      }
      return (a.distanceKm ?? Infinity) - (b.distanceKm ?? Infinity);
    });

    return { count: items.length, items };
  }

  /** FR-05 · Detalle del evento. */
  async findOne(id: string, deviceId?: string): Promise<EventDto> {
    const row = (await this.prisma.event.findUnique({
      where: { id },
      include: this.includeFor(deviceId),
    })) as EventRow | null;

    if (!row) {
      throw new NotFoundException('Ese evento no existe o fue dado de baja.');
    }

    return this.toDto(row, new Date());
  }

  /** FR-11 · "Mis eventos": todos los del organizador, incluso los que pasaron. */
  async listMine(
    deviceId: string,
  ): Promise<{ count: number; items: EventDto[] }> {
    const rows = (await this.prisma.event.findMany({
      where: { ownerDeviceId: deviceId },
      orderBy: { startsAt: 'desc' },
      include: this.includeFor(deviceId),
    })) as EventRow[];

    const now = new Date();
    const items = rows.map((row) => this.toDto(row, now));
    return { count: items.length, items };
  }

  /** FR-10 · Publicar. */
  async create(dto: CreateEventDto, deviceId: string): Promise<EventDto> {
    const startsAt = new Date(dto.startsAt);
    const endsAt = dto.endsAt ? new Date(dto.endsAt) : null;
    this.assertConsistentSchedule(startsAt, endsAt);

    const row = (await this.prisma.event.create({
      data: {
        name: dto.name,
        description: dto.description ?? null,
        startsAt,
        endsAt,
        priceCents: dto.priceCents,
        locationName: dto.locationName,
        reference: dto.reference ?? null,
        zone: dto.zone,
        latitude: dto.latitude ?? null,
        longitude: dto.longitude ?? null,
        imageUrl: dto.imageUrl ?? null,
        ownerDeviceId: deviceId,
      },
      include: this.includeFor(deviceId),
    })) as EventRow;

    return this.toDto(row, new Date());
  }

  /**
   * FR-12 · Editar en un solo lugar. Solo sella "actualizado recientemente" si
   * algo cambio de verdad: abrir el formulario y guardar sin tocar nada no
   * puede ensuciar la senal de vigencia que el usuario usa para confiar.
   */
  async update(
    id: string,
    dto: UpdateEventDto,
    deviceId: string,
  ): Promise<EventDto> {
    const current = await this.findOwned(id, deviceId);

    const startsAt = dto.startsAt ? new Date(dto.startsAt) : current.startsAt;
    const endsAt =
      dto.endsAt === undefined
        ? current.endsAt
        : dto.endsAt
          ? new Date(dto.endsAt)
          : null;
    this.assertConsistentSchedule(startsAt, endsAt);

    const data: Prisma.EventUpdateInput = {};
    if (dto.name !== undefined) data.name = dto.name;
    if (dto.description !== undefined) data.description = dto.description;
    if (dto.startsAt !== undefined) data.startsAt = startsAt;
    if (dto.endsAt !== undefined) data.endsAt = endsAt;
    if (dto.priceCents !== undefined) data.priceCents = dto.priceCents;
    if (dto.locationName !== undefined) data.locationName = dto.locationName;
    if (dto.reference !== undefined) data.reference = dto.reference;
    if (dto.zone !== undefined) data.zone = dto.zone;
    if (dto.latitude !== undefined) data.latitude = dto.latitude;
    if (dto.longitude !== undefined) data.longitude = dto.longitude;
    if (dto.imageUrl !== undefined) data.imageUrl = dto.imageUrl;

    if (this.changesSomething(current, data)) {
      data.lastEditedAt = new Date();
    }

    const row = (await this.prisma.event.update({
      where: { id },
      data,
      include: this.includeFor(deviceId),
    })) as EventRow;

    return this.toDto(row, new Date());
  }

  /** FR-12 · Cancelar marca, no borra. */
  async cancel(id: string, deviceId: string): Promise<EventDto> {
    await this.findOwned(id, deviceId);

    const row = (await this.prisma.event.update({
      where: { id },
      data: { status: EventStatus.CANCELLED },
      include: this.includeFor(deviceId),
    })) as EventRow;

    return this.toDto(row, new Date());
  }

  /** OQ-4 · La propiedad del evento es el dispositivo que lo creo. */
  private async findOwned(id: string, deviceId: string): Promise<Event> {
    const event = await this.prisma.event.findUnique({ where: { id } });

    if (!event) {
      throw new NotFoundException('Ese evento no existe o fue dado de baja.');
    }

    if (event.ownerDeviceId !== deviceId) {
      throw new ForbiddenException(
        'Solo se puede editar un evento desde el dispositivo que lo publicó.',
      );
    }

    return event;
  }

  private assertConsistentSchedule(startsAt: Date, endsAt: Date | null): void {
    if (endsAt && endsAt.getTime() <= startsAt.getTime()) {
      throw new BadRequestException(
        'La hora de fin tiene que ser posterior a la de inicio.',
      );
    }
  }

  private changesSomething(
    current: Event,
    data: Prisma.EventUpdateInput,
  ): boolean {
    return Object.entries(data).some(([key, value]) => {
      const previous = current[key as keyof Event];
      if (previous instanceof Date && value instanceof Date) {
        return previous.getTime() !== value.getTime();
      }
      return previous !== value;
    });
  }

  /** FR-01 · Solo eventos cuya fecha/hora de fin todavia no paso. */
  private notFinishedYet(now: Date): Prisma.EventWhereInput {
    return {
      OR: [
        { endsAt: { gte: now } },
        {
          endsAt: null,
          startsAt: {
            gte: new Date(
              now.getTime() - DEFAULT_EVENT_DURATION_HOURS * MS_PER_HOUR,
            ),
          },
        },
      ],
    };
  }

  private includeFor(deviceId?: string) {
    return {
      _count: { select: { interests: true } },
      ...(deviceId
        ? { interests: { where: { deviceId }, select: { id: true }, take: 1 } }
        : {}),
    };
  }

  private originOf(
    query: ListEventsQueryDto,
  ): { latitude: number; longitude: number } | undefined {
    if (query.latitude === undefined || query.longitude === undefined) {
      return undefined;
    }
    return { latitude: query.latitude, longitude: query.longitude };
  }

  private toDto(
    row: EventRow,
    now: Date,
    origin?: { latitude: number; longitude: number },
  ): EventDto {
    const distanceKm =
      origin && row.latitude !== null && row.longitude !== null
        ? Number(
            distanceInKm(
              origin.latitude,
              origin.longitude,
              row.latitude,
              row.longitude,
            ).toFixed(2),
          )
        : null;

    return {
      id: row.id,
      name: row.name,
      description: row.description,
      startsAt: row.startsAt.toISOString(),
      endsAt: row.endsAt ? row.endsAt.toISOString() : null,
      priceCents: row.priceCents,
      currency: row.currency,
      isFree: row.priceCents === 0,
      locationName: row.locationName,
      reference: row.reference,
      zone: row.zone,
      latitude: row.latitude,
      longitude: row.longitude,
      imageUrl: row.imageUrl,
      validity: resolveValidity(row, now),
      lastEditedAt: row.lastEditedAt ? row.lastEditedAt.toISOString() : null,
      // FR-09 · el interes sale como numero. La API nunca expone quienes son.
      interestCount: row._count.interests,
      interested: (row.interests?.length ?? 0) > 0,
      distanceKm,
    };
  }
}
