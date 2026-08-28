/**
 * FR-04 · Zonas de Santa Cruz de la Sierra para filtrar y ubicar.
 *
 * Es una lista cerrada a propósito: si el organizador escribe la zona a mano,
 * el filtro deja de funcionar (dos personas escriben "Equipetrol" y "equipetrol"
 * y son dos zonas distintas). OQ-9 sigue abierta sobre si el usuario prefiere
 * zona o distancia exacta; el modelo soporta las dos y esta lista solo cierra
 * la mitad textual.
 */
export const ZONES = [
  'Centro',
  'Equipetrol',
  'Norte',
  'Sur',
  'Este',
  'Oeste',
  'Urubó',
  'Plan 3000',
  'Doble Vía La Guardia',
] as const;

export type Zone = (typeof ZONES)[number];
