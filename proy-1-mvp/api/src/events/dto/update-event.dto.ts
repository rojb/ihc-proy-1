import { PartialType } from '@nestjs/mapped-types';
import { CreateEventDto } from './create-event.dto';

/**
 * FR-12 · Un solo lugar para corregir hora, precio o ubicación. Todo opcional:
 * el organizador manda solo lo que cambió.
 */
export class UpdateEventDto extends PartialType(CreateEventDto) {}
