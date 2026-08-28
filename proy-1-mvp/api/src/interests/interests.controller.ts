import {
  Controller,
  Delete,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Put,
} from '@nestjs/common';
import { DeviceId } from '../common/device-id.decorator';
import { InterestsService } from './interests.service';

/**
 * FR-08 · El interés cuelga del evento. Vive en el detalle, no en la tarjeta:
 * marcar interés supone haber verificado los datos (ver Apéndice B del PRD).
 */
@Controller('events/:id/interest')
export class InterestsController {
  constructor(private readonly interests: InterestsService) {}

  @Put()
  @HttpCode(HttpStatus.OK)
  mark(@Param('id', ParseUUIDPipe) id: string, @DeviceId() deviceId: string) {
    return this.interests.mark(id, deviceId);
  }

  @Delete()
  @HttpCode(HttpStatus.OK)
  unmark(@Param('id', ParseUUIDPipe) id: string, @DeviceId() deviceId: string) {
    return this.interests.unmark(id, deviceId);
  }
}
