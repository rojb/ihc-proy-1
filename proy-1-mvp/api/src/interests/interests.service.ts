import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

export interface InterestStateDto {
  eventId: string;
  interestCount: number;
  interested: boolean;
}

/**
 * FR-08 / FR-09 · "Me interesa" revertible y contador anónimo.
 *
 * Todo lo que sale de acá es un número. No hay endpoint que devuelva quiénes
 * marcaron interés, ni siquiera para el organizador: FR-W03 lo excluye del
 * producto y el NFR de privacidad lo prohíbe explícitamente.
 */
@Injectable()
export class InterestsService {
  constructor(private readonly prisma: PrismaService) {}

  /** Marcar es idempotente: dos toques del mismo dispositivo cuentan uno. */
  async mark(eventId: string, deviceId: string): Promise<InterestStateDto> {
    await this.assertEventExists(eventId);

    await this.prisma.interest.upsert({
      where: { eventId_deviceId: { eventId, deviceId } },
      create: { eventId, deviceId },
      update: {},
    });

    return this.stateOf(eventId, deviceId);
  }

  /** FR-08 · Desmarcar no tiene costo ni penalización. */
  async unmark(eventId: string, deviceId: string): Promise<InterestStateDto> {
    await this.assertEventExists(eventId);

    await this.prisma.interest.deleteMany({ where: { eventId, deviceId } });

    return this.stateOf(eventId, deviceId);
  }

  private async assertEventExists(eventId: string): Promise<void> {
    const event = await this.prisma.event.findUnique({
      where: { id: eventId },
      select: { id: true },
    });

    if (!event) {
      throw new NotFoundException('Ese evento no existe o fue dado de baja.');
    }
  }

  private async stateOf(
    eventId: string,
    deviceId: string,
  ): Promise<InterestStateDto> {
    const [interestCount, own] = await Promise.all([
      this.prisma.interest.count({ where: { eventId } }),
      this.prisma.interest.findUnique({
        where: { eventId_deviceId: { eventId, deviceId } },
        select: { id: true },
      }),
    ]);

    return { eventId, interestCount, interested: own !== null };
  }
}
