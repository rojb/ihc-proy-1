import { EventStatus, PrismaClient } from '@prisma/client';

/**
 * Datos de prueba del MVP (PRD §9: "el MVP corre con datos de prueba").
 *
 * Los eventos son ficticios; los lugares y zonas son de Santa Cruz de la Sierra
 * para que la evaluación con usuarios se sienta creíble. Las fechas se calculan
 * relativas al momento de correr el seed, así el set no vence: si estuvieran
 * fijas, la lista aparecería vacía la semana siguiente y FR-01 no se podría
 * probar.
 */

const prisma = new PrismaClient();

const BOLIVIA_OFFSET_HOURS = -4;
const MS_PER_HOUR = 3_600_000;

/** Dispositivo dueño de los eventos semilla, para poder probar FR-11 y FR-12. */
const SEED_ORGANIZER_DEVICE_ID = 'seed-organizador-demo';

/** Fecha/hora en el huso de Santa Cruz, expresada como días desde hoy. */
function boliviaDate(daysFromToday: number, hour: number, minute = 0): Date {
  const wallNow = new Date(Date.now() + BOLIVIA_OFFSET_HOURS * MS_PER_HOUR);
  return new Date(
    Date.UTC(
      wallNow.getUTCFullYear(),
      wallNow.getUTCMonth(),
      wallNow.getUTCDate() + daysFromToday,
      hour,
      minute,
    ) -
      BOLIVIA_OFFSET_HOURS * MS_PER_HOUR,
  );
}

/** Días hasta el viernes del fin de semana en curso o próximo. */
function daysUntilFriday(): number {
  const wallNow = new Date(Date.now() + BOLIVIA_OFFSET_HOURS * MS_PER_HOUR);
  const dayOfWeek = wallNow.getUTCDay(); // 0 domingo … 6 sábado
  if (dayOfWeek === 6) return -1;
  if (dayOfWeek === 0) return -2;
  return 5 - dayOfWeek;
}

const FRIDAY = daysUntilFriday();
const SATURDAY = FRIDAY + 1;
const SUNDAY = FRIDAY + 2;

/** Coordenadas aproximadas del centro de cada zona, para calcular distancia. */
const ZONE_COORDS: Record<string, { lat: number; lng: number }> = {
  Centro: { lat: -17.7833, lng: -63.1821 },
  Equipetrol: { lat: -17.7614, lng: -63.1975 },
  Norte: { lat: -17.7301, lng: -63.1702 },
  Sur: { lat: -17.8251, lng: -63.1654 },
  Este: { lat: -17.7854, lng: -63.1204 },
  Oeste: { lat: -17.7902, lng: -63.2203 },
  Urubó: { lat: -17.7603, lng: -63.2501 },
  'Plan 3000': { lat: -17.8304, lng: -63.1103 },
  'Doble Vía La Guardia': { lat: -17.8502, lng: -63.2304 },
};

interface SeedEvent {
  name: string;
  description?: string;
  daysFromToday: number;
  hour: number;
  minute?: number;
  durationHours?: number;
  priceCents: number;
  locationName: string;
  reference?: string;
  zone: keyof typeof ZONE_COORDS;
  status?: EventStatus;
  /** Horas desde ahora hacia atrás en que se editó, para probar FR-03. */
  editedHoursAgo?: number;
  /** Cuántos dispositivos marcaron interés (FR-09). */
  interestedDevices?: number;
}

const EVENTS: SeedEvent[] = [
  // --- Hoy -------------------------------------------------------------
  {
    name: 'Noche de jazz en vivo',
    description: 'Trío local tocando standards. Entrada por orden de llegada.',
    daysFromToday: 0,
    hour: 21,
    priceCents: 3500,
    locationName: 'Café Lorca',
    reference: 'Frente a la plaza principal',
    zone: 'Centro',
    interestedDevices: 12,
  },
  {
    name: 'Feria de emprendedores',
    description: 'Puestos de comida, artesanía y ropa de diseño independiente.',
    daysFromToday: 0,
    hour: 18,
    durationHours: 5,
    priceCents: 0,
    locationName: 'Manzana Uno',
    reference: 'Plaza 24 de Septiembre',
    zone: 'Centro',
    interestedDevices: 34,
  },
  {
    name: 'Torneo de fútbol 5 abierto',
    daysFromToday: 0,
    hour: 20,
    priceCents: 2000,
    locationName: 'Complejo Deportivo Las Palmas',
    zone: 'Norte',
    interestedDevices: 5,
  },

  // --- Este fin de semana ---------------------------------------------
  {
    name: 'Fiesta electrónica: Verano Anticipado',
    description: 'Tres DJ locales. Entrada general, cupo limitado.',
    daysFromToday: FRIDAY,
    hour: 23,
    durationHours: 6,
    priceCents: 12000,
    locationName: 'Club Nocturno Ávila',
    reference: 'Segundo anillo, sobre la avenida',
    zone: 'Equipetrol',
    interestedDevices: 87,
  },
  {
    name: 'Stand up: Risas del Oriente',
    description: 'Cuatro comediantes cruceños. Función única.',
    daysFromToday: FRIDAY,
    hour: 21,
    priceCents: 5000,
    locationName: 'Teatro Municipal',
    zone: 'Centro',
    interestedDevices: 41,
  },
  {
    name: 'Cine al aire libre: clásicos bolivianos',
    description: 'Proyección con manta y reposera. Llevá tu silla.',
    daysFromToday: FRIDAY,
    hour: 19,
    priceCents: 0,
    locationName: 'Parque Urbano Central',
    reference: 'Entrada por el tercer anillo',
    zone: 'Centro',
    interestedDevices: 63,
  },
  {
    name: 'Peña folclórica con banda en vivo',
    daysFromToday: SATURDAY,
    hour: 20,
    durationHours: 5,
    priceCents: 8000,
    locationName: 'Casa del Camba',
    zone: 'Norte',
    interestedDevices: 29,
  },
  {
    name: 'Rock local: cuatro bandas, una noche',
    description: 'Bandas emergentes de la escena cruceña.',
    daysFromToday: SATURDAY,
    hour: 22,
    priceCents: 4000,
    locationName: 'Galpón 7',
    reference: 'Detrás del mercado',
    zone: 'Este',
    editedHoursAgo: 6, // FR-03 · aparece como "actualizado recientemente"
    interestedDevices: 18,
  },
  {
    name: 'Taller de cerámica para principiantes',
    description: 'Materiales incluidos. Cupo para 15 personas.',
    daysFromToday: SATURDAY,
    hour: 15,
    durationHours: 3,
    priceCents: 15000,
    locationName: 'Estudio Barro',
    zone: 'Urubó',
    interestedDevices: 7,
  },
  {
    name: 'Feria gastronómica del Urubó',
    daysFromToday: SATURDAY,
    hour: 12,
    durationHours: 8,
    priceCents: 0,
    locationName: 'Explanada del Urubó',
    reference: 'Pasando el puente',
    zone: 'Urubó',
    interestedDevices: 52,
  },
  {
    name: 'Karaoke competitivo',
    daysFromToday: SATURDAY,
    hour: 21,
    priceCents: 2500,
    locationName: 'Bar La Esquina',
    zone: 'Equipetrol',
    interestedDevices: 9,
  },
  {
    name: 'Torneo de ajedrez relámpago',
    daysFromToday: SUNDAY,
    hour: 10,
    durationHours: 5,
    priceCents: 3000,
    locationName: 'Club de Ajedrez Santa Cruz',
    zone: 'Centro',
    interestedDevices: 4,
  },
  {
    name: 'Domingo de food trucks',
    description: 'Doce food trucks y música ambiente.',
    daysFromToday: SUNDAY,
    hour: 17,
    durationHours: 6,
    priceCents: 0,
    locationName: 'Playón del Cristo',
    zone: 'Centro',
    interestedDevices: 76,
  },
  {
    name: 'Clase abierta de salsa',
    daysFromToday: SUNDAY,
    hour: 19,
    priceCents: 2000,
    locationName: 'Academia Sabor Latino',
    zone: 'Sur',
    interestedDevices: 15,
  },
  {
    name: 'Concierto sinfónico de cámara',
    description: 'Programa de música latinoamericana.',
    daysFromToday: SUNDAY,
    hour: 20,
    priceCents: 25000,
    locationName: 'Teatro René Moreno',
    zone: 'Centro',
    interestedDevices: 22,
  },
  {
    name: 'Fiesta de disfraces cancelada por lluvia',
    description: 'Se reprograma. Quienes marcaron interés verán el aviso.',
    daysFromToday: SATURDAY,
    hour: 23,
    priceCents: 10000,
    locationName: 'Terraza Norte',
    zone: 'Norte',
    status: EventStatus.CANCELLED, // FR-03 · se muestra marcado, no desaparece
    interestedDevices: 31,
  },

  // --- Próxima semana ---------------------------------------------------
  {
    name: 'Exposición de fotografía urbana',
    description: 'Muestra colectiva de doce fotógrafos cruceños.',
    daysFromToday: SUNDAY + 2,
    hour: 18,
    durationHours: 4,
    priceCents: 0,
    locationName: 'Centro Cultural Santa Cruz',
    zone: 'Centro',
    interestedDevices: 11,
  },
  {
    name: 'Noche de trivia en inglés',
    daysFromToday: SUNDAY + 3,
    hour: 20,
    priceCents: 3000,
    locationName: 'Pub El Faro',
    zone: 'Equipetrol',
    interestedDevices: 6,
  },
  {
    name: 'Maratón 10K nocturna',
    description: 'Inscripción con remera incluida. Largada desde el segundo anillo.',
    daysFromToday: SUNDAY + 4,
    hour: 19,
    durationHours: 3,
    priceCents: 7000,
    locationName: 'Avenida Roca y Coronado',
    zone: 'Sur',
    interestedDevices: 48,
  },
  {
    name: 'Obra de teatro independiente',
    daysFromToday: SUNDAY + 5,
    hour: 20,
    priceCents: 4500,
    locationName: 'Sala Alterna',
    reference: 'Casa de dos pisos, portón verde',
    zone: 'Oeste',
    interestedDevices: 13,
  },
  {
    name: 'Feria del libro usado',
    daysFromToday: SUNDAY + 6,
    hour: 9,
    durationHours: 9,
    priceCents: 0,
    locationName: 'Plaza del Estudiante',
    zone: 'Plan 3000',
    interestedDevices: 25,
  },
  {
    name: 'Festival de cumbia',
    description: 'Seis agrupaciones en vivo hasta la madrugada.',
    daysFromToday: SUNDAY + 6,
    hour: 21,
    durationHours: 7,
    priceCents: 35000,
    locationName: 'Predio Ferial',
    zone: 'Doble Vía La Guardia',
    interestedDevices: 142,
  },
  {
    name: 'Mercado de plantas y viveros',
    daysFromToday: SUNDAY + 7,
    hour: 8,
    durationHours: 6,
    priceCents: 0,
    locationName: 'Parque Los Mangales',
    zone: 'Norte',
    interestedDevices: 19,
  },
  {
    name: 'Cata de cervezas artesanales',
    description: 'Seis etiquetas locales con maridaje.',
    daysFromToday: SUNDAY + 8,
    hour: 19,
    durationHours: 3,
    priceCents: 18000,
    locationName: 'Cervecería El Tapón',
    zone: 'Equipetrol',
    interestedDevices: 16,
  },
];

async function main(): Promise<void> {
  // Orden importa: Interest referencia Event.
  await prisma.interest.deleteMany();
  await prisma.event.deleteMany();

  const now = Date.now();

  for (const [index, seed] of EVENTS.entries()) {
    const startsAt = boliviaDate(seed.daysFromToday, seed.hour, seed.minute);
    const endsAt = seed.durationHours
      ? new Date(startsAt.getTime() + seed.durationHours * MS_PER_HOUR)
      : null;

    // Dispersión determinista alrededor del centro de la zona (~1 km). Sin
    // esto todos los eventos de una zona caen en el mismo punto y la distancia
    // da idéntica para todos, que es justo lo que OQ-9 necesita poder observar.
    const zoneCenter = ZONE_COORDS[seed.zone];
    const coords = {
      lat: Number((zoneCenter.lat + ((index % 7) - 3) * 0.004).toFixed(6)),
      lng: Number((zoneCenter.lng + ((index % 5) - 2) * 0.005).toFixed(6)),
    };

    const event = await prisma.event.create({
      data: {
        name: seed.name,
        description: seed.description ?? null,
        startsAt,
        endsAt,
        priceCents: seed.priceCents,
        locationName: seed.locationName,
        reference: seed.reference ?? null,
        zone: seed.zone,
        latitude: coords.lat,
        longitude: coords.lng,
        status: seed.status ?? EventStatus.ACTIVE,
        ownerDeviceId: SEED_ORGANIZER_DEVICE_ID,
        lastEditedAt: seed.editedHoursAgo
          ? new Date(now - seed.editedHoursAgo * MS_PER_HOUR)
          : null,
      },
    });

    const interested = seed.interestedDevices ?? 0;
    if (interested > 0) {
      await prisma.interest.createMany({
        data: Array.from({ length: interested }, (_, index) => ({
          eventId: event.id,
          deviceId: `seed-dispositivo-${event.id.slice(0, 8)}-${index}`,
        })),
      });
    }
  }

  const [events, interests] = await Promise.all([
    prisma.event.count(),
    prisma.interest.count(),
  ]);

  console.log(`Seed listo: ${events} eventos, ${interests} marcas de interés.`);
  console.log(`Dispositivo organizador de prueba: ${SEED_ORGANIZER_DEVICE_ID}`);
}

main()
  .catch((error: unknown) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(() => {
    void prisma.$disconnect();
  });
