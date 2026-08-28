/// Zonas de Santa Cruz de la Sierra. Espeja la lista del backend
/// (`api/src/common/zones.ts`): si una cambia, la otra tiene que cambiar.
const List<String> kZones = <String>[
  'Centro',
  'Equipetrol',
  'Norte',
  'Sur',
  'Este',
  'Oeste',
  'Urubó',
  'Plan 3000',
  'Doble Vía La Guardia',
];

/// Centro aproximado de cada zona.
///
/// FR-04 pide filtrar por distancia. En vez de pedir permiso de ubicación
/// —fricción alta en una tarea de consumo, y el PRD evita permisos— la persona
/// elige su zona y la distancia se mide desde este punto. OQ-9 sigue abierta:
/// esto permite observar si la gente razona en distancia o en zona.
const Map<String, ({double latitude, double longitude})> kZoneCenters = {
  'Centro': (latitude: -17.7833, longitude: -63.1821),
  'Equipetrol': (latitude: -17.7614, longitude: -63.1975),
  'Norte': (latitude: -17.7301, longitude: -63.1702),
  'Sur': (latitude: -17.8251, longitude: -63.1654),
  'Este': (latitude: -17.7854, longitude: -63.1204),
  'Oeste': (latitude: -17.7902, longitude: -63.2203),
  'Urubó': (latitude: -17.7603, longitude: -63.2501),
  'Plan 3000': (latitude: -17.8304, longitude: -63.1103),
  'Doble Vía La Guardia': (latitude: -17.8502, longitude: -63.2304),
};

/// Centro de una zona, o null si el nombre no está en la lista.
({double latitude, double longitude})? kZoneCenterOf(String zone) =>
    kZoneCenters[zone];
