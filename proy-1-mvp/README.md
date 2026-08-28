# MVP — App de eventos en Santa Cruz de la Sierra

Implementación del [PRD v0.1](prd/prd-v0.1.md). Proyecto de la materia IHC.

| Pieza | Stack | Carpeta |
|---|---|---|
| App móvil | Flutter · Provider | `app/` |
| API | NestJS · Prisma | `api/` |
| Base de datos | PostgreSQL en Docker | `docker-compose.yml` |

## Levantarlo

Hacen falta Node 20+, Flutter 3.27+ y Docker.

```bash
# 1. Base de datos
docker compose up -d

# 2. API
cd api
npm install
npx prisma migrate dev        # crea las tablas
npm run db:seed               # 24 eventos de prueba
npm run start:dev             # queda en http://localhost:3000/api

# 3. App (en otra terminal)
cd app
flutter pub get
flutter run
```

### Dónde busca la API la app

| Dónde corre | URL que usa |
|---|---|
| Emulador Android | `http://10.0.2.2:3000/api` |
| Web / escritorio | `http://localhost:3000/api` |
| Dispositivo físico | hay que pasarla a mano |

Para un celular real, con la computadora y el teléfono en la misma red:

```bash
flutter run --dart-define=API_BASE_URL=http://TU_IP_LOCAL:3000/api
```

## Cómo está organizado

Sin arquitectura hexagonal ni clean: cada framework se usa como viene.

**API** — módulos de Nest (`module` / `controller` / `service`) y Prisma como acceso a datos.

```
api/src/
├── events/       FR-01 a FR-05, FR-10 a FR-12 — lista, filtros, detalle, publicar, editar
├── interests/    FR-08, FR-09 — marcar interés y contador
├── common/       vigencia, husos horarios, distancia, header de dispositivo
└── prisma/
```

**App** — la única regla que se sostiene: los widgets no hablan HTTP.

```
app/lib/
├── api/          cliente HTTP y modelos. El único lugar que conoce el JSON
├── state/        ChangeNotifier: lista + filtros + caché, y organizador
├── ui/           pantallas y widgets
└── share_message.dart   FR-06 — el mensaje que va al grupo
```

## Decisiones que cierran preguntas abiertas del PRD

Son decisiones del equipo, no hallazgos de investigación. Están para que la
evaluación con usuarios (M6) pueda observarlas, no para darlas por buenas.

| Pregunta | Qué se implementó |
|---|---|
| **OQ-1** — identificación mínima para el contador | UUID generado al primer uso y guardado en el dispositivo. Es lo que ya decía FR-07 |
| **OQ-4** — cómo edita el organizador | El mismo UUID es dueño del evento. Editar y cancelar solo desde el dispositivo que publicó |
| **OQ-8** — ¿la tarjeta necesita imagen? | Sin imagen, y el precio ocupa el lugar de más peso. Entran 4 tarjetas completas en pantalla |
| **OQ-9** — ¿distancia o zona? | Las dos. La persona elige desde qué zona sale y la distancia se calcula desde ahí, sin pedir GPS |
| **OQ-3** — umbral del contador | Sin umbral: se muestra el número siempre. Es lo que hay que observar en M6 |

## Lo que no está

- **FR-15** guardar para más tarde, **FR-16** umbral del contador, **FR-17** aviso
  a interesados cuando se cancela. Son *Could Have* y quedaron afuera.
- Imágenes de evento: el modelo tiene el campo, la carga no está.
- Tests. Se sacaron por decisión del equipo.

## Datos de prueba

`npm run db:seed` carga 24 eventos con fechas **relativas al momento de correr
el seed**, así el set no vence. Incluye eventos gratis y de hasta Bs 350, las
nueve zonas, uno cancelado y uno editado recientemente, para que los tres
estados de vigencia (FR-03) se vean en la lista.

El organizador de prueba es el dispositivo `seed-organizador-demo`. Los eventos
sembrados le pertenecen, así que **no** aparecen en "Mis eventos" de tu
dispositivo: para probar FR-10 a FR-12 hay que publicar uno propio.

Para volver a empezar de cero:

```bash
cd api && npm run db:reset && npm run db:seed
```
