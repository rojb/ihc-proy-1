import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import { DeviceId, OptionalDeviceId } from '../common/device-id.decorator';
import { CreateEventDto } from './dto/create-event.dto';
import { ListEventsQueryDto } from './dto/list-events.query.dto';
import { UpdateEventDto } from './dto/update-event.dto';
import { EventsService } from './events.service';

@Controller('events')
export class EventsController {
  constructor(private readonly events: EventsService) {}

  /** FR-01 + FR-04 · La lista es la pantalla de inicio; los filtros son query. */
  @Get()
  list(
    @Query() query: ListEventsQueryDto,
    @OptionalDeviceId() deviceId?: string,
  ) {
    return this.events.list(query, deviceId);
  }

  /**
   * FR-11 · Tiene que declararse antes de `:id`, si no Nest resuelve "mine"
   * como si fuera un identificador de evento.
   */
  @Get('mine')
  mine(@DeviceId() deviceId: string) {
    return this.events.listMine(deviceId);
  }

  /** FR-05 · Detalle. */
  @Get(':id')
  detail(
    @Param('id', ParseUUIDPipe) id: string,
    @OptionalDeviceId() deviceId?: string,
  ) {
    return this.events.findOne(id, deviceId);
  }

  /** FR-10 · Publicar. */
  @Post()
  create(@Body() dto: CreateEventDto, @DeviceId() deviceId: string) {
    return this.events.create(dto, deviceId);
  }

  /** FR-12 · Editar. */
  @Patch(':id')
  update(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: UpdateEventDto,
    @DeviceId() deviceId: string,
  ) {
    return this.events.update(id, dto, deviceId);
  }

  /** FR-12 · Cancelar: marca el evento, no lo borra. */
  @Post(':id/cancel')
  @HttpCode(HttpStatus.OK)
  cancel(
    @Param('id', ParseUUIDPipe) id: string,
    @DeviceId() deviceId: string,
  ) {
    return this.events.cancel(id, deviceId);
  }
}
