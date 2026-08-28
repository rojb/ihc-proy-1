import { Type } from 'class-transformer';
import { IsIn, IsInt, IsNumber, IsOptional, Min } from 'class-validator';
import { ZONES } from '../../common/zones';

export const DATE_FILTERS = ['today', 'weekend'] as const;
export type DateFilter = (typeof DATE_FILTERS)[number];

/**
 * FR-04 · Filtros básicos: fecha, precio y distancia/zona. Combinables.
 * Todos opcionales: sin filtros, la respuesta es la lista completa de vigentes,
 * que es la pantalla de inicio (FR-01).
 */
export class ListEventsQueryDto {
  @IsOptional()
  @IsIn(DATE_FILTERS)
  when?: DateFilter;

  /** Tope de precio en centavos. `0` deja solo los gratuitos. */
  @IsOptional()
  @IsInt()
  @Min(0)
  @Type(() => Number)
  maxPriceCents?: number;

  @IsOptional()
  @IsIn(ZONES)
  zone?: string;

  @IsOptional()
  @IsNumber()
  @Type(() => Number)
  latitude?: number;

  @IsOptional()
  @IsNumber()
  @Type(() => Number)
  longitude?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Type(() => Number)
  radiusKm?: number;
}
