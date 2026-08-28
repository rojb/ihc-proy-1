import { EARTH_RADIUS_KM } from './constants';

const toRadians = (degrees: number): number => (degrees * Math.PI) / 180;

/**
 * Distancia haversine en km. Se calcula en memoria y no en Postgres a
 * propósito: el MVP corre con un set de datos de prueba chico (PRD §9), y
 * meter PostGIS por veinte eventos es pagar complejidad sin necesidad.
 */
export function distanceInKm(
  fromLat: number,
  fromLng: number,
  toLat: number,
  toLng: number,
): number {
  const deltaLat = toRadians(toLat - fromLat);
  const deltaLng = toRadians(toLng - fromLng);

  const a =
    Math.sin(deltaLat / 2) ** 2 +
    Math.cos(toRadians(fromLat)) *
      Math.cos(toRadians(toLat)) *
      Math.sin(deltaLng / 2) ** 2;

  return EARTH_RADIUS_KM * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}
