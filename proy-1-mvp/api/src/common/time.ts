import { BOLIVIA_UTC_OFFSET_HOURS } from './constants';

const MS_PER_HOUR = 3_600_000;
const MS_PER_DAY = 86_400_000;

/** Corre el instante para poder leer la hora local de Bolivia con getUTC*. */
function toWallClock(instant: Date): Date {
  return new Date(instant.getTime() + BOLIVIA_UTC_OFFSET_HOURS * MS_PER_HOUR);
}

/** Convierte una hora de pared boliviana al instante UTC que le corresponde. */
function fromWallClock(
  year: number,
  month: number,
  day: number,
  hours = 0,
  minutes = 0,
  seconds = 0,
  ms = 0,
): Date {
  return new Date(
    Date.UTC(year, month, day, hours, minutes, seconds, ms) -
      BOLIVIA_UTC_OFFSET_HOURS * MS_PER_HOUR,
  );
}

export function startOfDayInBolivia(instant: Date): Date {
  const wall = toWallClock(instant);
  return fromWallClock(
    wall.getUTCFullYear(),
    wall.getUTCMonth(),
    wall.getUTCDate(),
  );
}

export function endOfDayInBolivia(instant: Date): Date {
  const wall = toWallClock(instant);
  return fromWallClock(
    wall.getUTCFullYear(),
    wall.getUTCMonth(),
    wall.getUTCDate(),
    23,
    59,
    59,
    999,
  );
}

/**
 * FR-04 · "Este fin de semana" = viernes 00:00 a domingo 23:59 hora local.
 * Si ya es sábado o domingo devuelve el fin de semana en curso, no el próximo:
 * la persona que abre la app un sábado a la tarde busca hoy, no dentro de seis
 * días (persona v0.1 — decide el mismo día).
 */
export function weekendRangeInBolivia(instant: Date): { from: Date; to: Date } {
  const wall = toWallClock(instant);
  const dayOfWeek = wall.getUTCDay(); // 0 domingo … 5 viernes, 6 sábado

  let daysUntilFriday: number;
  if (dayOfWeek === 6) {
    daysUntilFriday = -1; // sábado: el viernes fue ayer
  } else if (dayOfWeek === 0) {
    daysUntilFriday = -2; // domingo: el viernes fue anteayer
  } else {
    daysUntilFriday = 5 - dayOfWeek; // lunes a viernes
  }

  const friday = new Date(wall.getTime() + daysUntilFriday * MS_PER_DAY);
  const sunday = new Date(friday.getTime() + 2 * MS_PER_DAY);

  return {
    from: fromWallClock(
      friday.getUTCFullYear(),
      friday.getUTCMonth(),
      friday.getUTCDate(),
    ),
    to: fromWallClock(
      sunday.getUTCFullYear(),
      sunday.getUTCMonth(),
      sunday.getUTCDate(),
      23,
      59,
      59,
      999,
    ),
  };
}
