/**
 * Constantes de dominio. Cada una responde a un requisito del PRD v0.1;
 * cambiar un valor acá cambia lo que el usuario ve, no solo un detalle técnico.
 */

/**
 * FR-01 · Un evento sigue vigente hasta su fin. Cuando el organizador no cargó
 * `endsAt` (es opcional en FR-10) asumimos esta duración desde el inicio, para
 * que un evento de las 22:00 no desaparezca de la lista a las 22:01.
 */
export const DEFAULT_EVENT_DURATION_HOURS = 4;

/**
 * FR-03 · Ventana durante la cual un evento editado se muestra como
 * "actualizado recientemente". Pasada la ventana vuelve a estado vigente.
 */
export const RECENTLY_UPDATED_WINDOW_HOURS = 72;

/**
 * América/La_Paz no tiene horario de verano, así que un desfase fijo alcanza
 * para calcular "hoy" y "este fin de semana" en hora local de Santa Cruz.
 */
export const BOLIVIA_UTC_OFFSET_HOURS = -4;

/** Radio de la Tierra en km, para la distancia haversine. */
export const EARTH_RADIUS_KM = 6371;
