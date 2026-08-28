import { Type } from 'class-transformer';
import {
  IsIn,
  IsInt,
  IsISO8601,
  IsLatitude,
  IsLongitude,
  IsOptional,
  IsString,
  IsUrl,
  Length,
  Min,
} from 'class-validator';
import { ZONES } from '../../common/zones';

/**
 * FR-10 · Formulario corto. Los obligatorios son exactamente cuatro: nombre,
 * inicio, precio y ubicación. Cada campo extra que se vuelva obligatorio acá
 * atenta contra el objetivo de publicar en ≤ 120 s (KR7).
 */
export class CreateEventDto {
  @IsString()
  @Length(3, 80, { message: 'El nombre debe tener entre 3 y 80 caracteres.' })
  name!: string;

  @IsISO8601({}, { message: 'La fecha de inicio debe ser una fecha válida.' })
  startsAt!: string;

  /** FR-02 · 0 es "Gratis". Nunca se acepta vacío. */
  @IsInt({ message: 'El precio debe expresarse en centavos, sin decimales.' })
  @Min(0, { message: 'El precio no puede ser negativo. Usá 0 para "Gratis".' })
  @Type(() => Number)
  priceCents!: number;

  @IsString()
  @Length(3, 120)
  locationName!: string;

  @IsIn(ZONES, { message: `La zona debe ser una de: ${ZONES.join(', ')}.` })
  zone!: string;

  @IsOptional()
  @IsISO8601({}, { message: 'La fecha de fin debe ser una fecha válida.' })
  endsAt?: string;

  @IsOptional()
  @IsString()
  @Length(0, 500)
  description?: string;

  @IsOptional()
  @IsString()
  @Length(0, 120)
  reference?: string;

  @IsOptional()
  @IsUrl({}, { message: 'La imagen debe ser una URL válida.' })
  imageUrl?: string;

  @IsOptional()
  @IsLatitude()
  @Type(() => Number)
  latitude?: number;

  @IsOptional()
  @IsLongitude()
  @Type(() => Number)
  longitude?: number;
}
