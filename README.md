# Proyecto IHC — App de eventos en Santa Cruz de la Sierra

## Integrantes

| Nombre | Nro Registro |
|---|---|
| _Justiniano Becerra Ruben Orestes_ | _216163501_ |
| _Soliz Marquez Faryd Lucas_ | _221045880_ | 

## Tipo de proyecto

Aplicación móvil para descubrimiento de eventos locales, con enfoque en Interacción Humano–Computador: investigación de usuario, diseño de interacción, prototipado y evaluación con usuarios reales.

## Modalidad

Proyecto con IA — se utiliza asistencia de IA para exploración de ideas, redacción de documentos, generación de alternativas de diseño y apoyo en el desarrollo. Las decisiones de diseño y la validación con usuarios son responsabilidad del equipo.

## Problema inicial

Queremos comprender las dificultades que enfrentan las personas en Santa Cruz de la Sierra al buscar y decidir a qué evento asistir. La información existe, pero está dispersa entre historias de Instagram, grupos de WhatsApp y flyers sin fecha de vigencia; el precio y la ubicación exacta rara vez están visibles, y la decisión casi nunca es individual. En paralelo, buscamos entender qué barreras encuentran los organizadores pequeños al difundir sus eventos.

## Enlaces

| Qué | Dónde |
|---|---|
| Diseño en Figma | [Proyecto AppEventos](https://www.figma.com/design/QAZz0JHICsgl5Qj2yOR7qm/Proyecto-AppEventos?node-id=0-1) |
| Prototipo de wireframes | `wireframes/prototipo.html` — se abre en el navegador |
| MVP funcionando | `proy-1-mvp/README.md` — instrucciones para levantarlo |

## Estructura del repositorio

```
/
├── README.md
├── brief/
│   ├── brief-v0.1.md          # Hipótesis inicial
│   └── brief-v0.2.0.md        # Hipótesis revisada — documento vigente
├── research/
│   └── evidencias.md          # Entrevistas simuladas con IA
├── persona/
│   ├── persona-v0.1.md             # Camila — quien busca (primaria)
│   └── persona-organizador-v0.1.md # Marco — quien publica (secundaria)
├── app-map/
│   ├── app-map-v0.1.md              # Dónde encuentra cada cosa
│   ├── flujo-v0.1.md                # Flujo principal — quien busca
│   └── flujo-organizador-v0.1.md    # Segundo flujo — quien publica
└── wireframes/
    ├── README.md                    # Jerarquía, espaciado y cómo importar a Figma
    ├── prototipo.html               # Prototipo con vistas enlazadas
    ├── svg/                         # 7 pantallas — formato para Figma
    └── png/                         # Las mismas, renderizadas @2x
```

### Qué pregunta responde cada documento

| Documento | Pregunta |
|---|---|
| `brief/brief-v0.2.0.md` | ¿Qué problema resolvemos y con qué alcance? |
| `research/evidencias.md` | ¿En qué nos basamos para afirmarlo? |
| `persona/persona-v0.1.md` | ¿Para quién lo resolvemos? |
| `persona/persona-organizador-v0.1.md` | ¿Quién publica los eventos y qué le cuesta hoy? |
| `app-map/app-map-v0.1.md` | ¿Dónde encuentra esa persona lo que necesita? |
| `app-map/flujo-v0.1.md` | ¿Qué camino recorre para completar la tarea? |
| `app-map/flujo-organizador-v0.1.md` | ¿Cómo publica y actualiza un evento quien lo organiza? |
| `wireframes/README.md` | ¿Cómo se ordena cada pantalla y por qué? |

## Estado

**Fase de diseño de interacción.** Cerrada la investigación inicial, están definidos el problema, la persona, el mapa de la aplicación y el flujo principal.

| Etapa | Estado |
|---|---|
| Brief | v0.2.0 — vigente |
| Investigación | 4 entrevistas **simuladas con IA** |
| Persona — Camila (quien busca) | v0.1 |
| Persona — Marco (quien publica) | v0.1 — **respaldada por 1 sola instancia** |
| App map | v0.1 |
| Flujo principal — quien busca | v0.1 |
| Flujo del organizador — quien publica | v0.1 |
| Wireframes | v0.1 — 6 pantallas + escala de espaciado |
| Prototipo con vistas enlazadas | `wireframes/prototipo.html` |
| MVP en código | Pendiente |
| Evaluación con usuarios reales | Pendiente |

### Decisión de diseño más reciente

Se incorporó la acción **"Me interesa"**: una persona puede contar públicamente que quiere participar en un evento, y el interés se muestra como **contador anónimo** —un número, nunca una lista de nombres—. Está reflejada en el brief, el app map y el flujo.

### Advertencias abiertas

- **Ninguna hipótesis fue validada con usuarios reales.** La evidencia disponible proviene de entrevistas simuladas con IA y sirve para explorar, no para confirmar.
- **La acción "Me interesa" tiene respaldo desparejo.** Del lado del organizador hay apoyo parcial: hoy ya mide contando respuestas y preguntas. Del lado de quien compara no hay ninguno. Así está marcado en el brief.
- **La Persona del organizador se apoya en una sola instancia** de la investigación, frente a las tres que sostienen a Camila.
- **Riesgo identificado:** el contador de interesados puede generar sesgo de popularidad y perjudicar a los organizadores pequeños, que son el usuario secundario del proyecto.
- **Pendiente antes de implementar el contador:** definir qué identificación mínima evita contar dos veces a la misma persona.
