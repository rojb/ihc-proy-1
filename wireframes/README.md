# Wireframes v0.1

**Proyecto:** App de eventos en Santa Cruz de la Sierra
**Fecha:** 27/08/2026
**Base:** `app-map/app-map-v0.1.md`, `app-map/flujo-v0.1.md`, `app-map/flujo-organizador-v0.1.md`

> Wireframes de baja fidelidad: estructura, jerarquía y espaciado. **No** son diseño visual. No hay color, tipografía ni marca, y es deliberado: si el orden no se entiende en blanco y negro, no lo va a arreglar el color.

---

## Qué hay en esta carpeta

| Ruta | Qué es | Para qué sirve |
|---|---|---|
| `svg/` | 7 pantallas en SVG | **Importar a Figma** con capas y texto editables |
| `png/` | Las mismas pantallas en PNG @2x | Ver o pegar en un informe sin abrir Figma |
| `prototipo.html` | Prototipo con vistas enlazadas | **Probar la tarea** con otra persona, hoy, sin Figma |

---

## Las pantallas

### Flujo de Camila — quien busca

| # | Pantalla | Momento de la tarea |
|---|---|---|
| 01 | Lista de eventos | Está **comparando** opciones del fin de semana |
| 02 | Detalle del evento | Está **verificando** una antes de mandarla |
| 03 | Compartido | **Confirmó** que el mensaje salió completo |

### Flujo de Marco — quien publica

| # | Pantalla | Momento de la tarea |
|---|---|---|
| 04 | Publicar evento | Está **cargando** un evento nuevo |
| 05 | Mis eventos | Está **revisando** vigencia e interesados |
| 06 | Editar evento | Está **corrigiendo** un dato que cambió |

### Referencia

| # | Pantalla | Para qué |
|---|---|---|
| 00 | Escala de espaciado | Documenta la base 8 usada en todas las pantallas |

---

## Vistas enlazadas

```
        ┌──────────────────────────────────────────┐
        ▼                                          │
   01 Lista ──► 02 Detalle ──► 03 Compartido ──────┘
        │            │
        │            └── Me interesa (no navega: cambia de estado)
        │
        └──► 04 Publicar ──► 05 Mis eventos ──► 06 Editar
                   ▲               │                │
                   └───────────────┘◄───────────────┘
```

Abrí `prototipo.html` en el navegador. Tildá **"Mostrar zonas enlazadas"** para ver dónde se puede tocar.

---

## Jerarquía: qué se reconoce primero

Cada pantalla ordena la atención en tres niveles, como pide la clase:

| Nivel | En la lista (01) | En el detalle (02) | En editar (06) |
|---|---|---|---|
| **1 · Orientar** | "Eventos" + filtros activos | Nombre del evento | "Editar evento" |
| **2 · Informar** | Precio (el elemento más grande de la tarjeta) | Bloque de precio, fecha y lugar | El campo que cambió, con borde reforzado |
| **3 · Actuar** | Tocar la tarjeta | "Compartir al grupo", con borde grueso | "Guardar cambios" |

**Decisiones que se pueden explicar:**

- **El precio es el texto más grande de la tarjeta**, más que el nombre del evento. La evidencia dice que es criterio de descarte: si no se ve rápido, la opción queda fuera de la comparación.
- **"Compartir al grupo" tiene borde grueso; "Me interesa" no.** Hay una sola acción principal por pantalla. Si las dos pesan igual, ninguna pesa.
- **El contador de interesados está alineado a la derecha y en tamaño chico.** Es dato de apoyo, no de descarte: no debe competir con el precio.
- **En editar, el campo modificado tiene el borde reforzado.** La pantalla acompaña la razón por la que Marco entró.

---

## Espaciado: base 8

| Valor | Se usa entre |
|---|---|
| **8 px** | Etiqueta y campo · dato y unidad |
| **16 px** | Contenido relacionado · margen lateral de la pantalla |
| **24 px** | Grupos distintos dentro de la misma pantalla |
| **32 px** | Secciones o momentos distintos de la tarea |

**Medidas de los componentes, todas múltiplos de 8:** header 64 · barra inferior 72 · acción principal 56 · campo de formulario 48 · acción secundaria 48 · chip de filtro 40 · tarjeta de evento 112 · fila de "Mis eventos" 96 · indicador de vigencia 88 × 24.

**Dos medidas que no son múltiplos de 8, y el motivo:** el ancho de pantalla es **375** porque lo fija el dispositivo, no nosotros; y el ancho de contenido es **343** porque sale de restarle los dos márgenes de 16. Ninguna de las dos es una decisión de espaciado.

Equivalente en CSS, para cuando esto pase al código:

```css
:root {
  --space-1: 8px;
  --space-2: 16px;
  --space-3: 24px;
  --space-4: 32px;
}
```

---

## Cómo llevarlo a Figma

**Los SVG son el formato bueno.** Figma los importa como vectores: cada rectángulo es una capa y cada texto se sigue pudiendo editar.

1. En Figma: **File → Import…** (o arrastrá los 7 archivos de `svg/` al canvas).
2. Cada archivo entra como un grupo. Seleccionalo y **Ctrl/Cmd + Alt + G** para convertirlo en Frame.
3. Renombrá cada frame con el **momento de la tarea**, no con el nombre de la pantalla: `Comparando`, `Verificando`, `Compartido`, `Publicando`, `Revisando`, `Corrigiendo`.
4. Para las vistas enlazadas: pestaña **Prototype**, arrastrá el conector desde la zona que se toca hasta el frame destino. El mapa de enlaces está más arriba y en `prototipo.html`.

**Lo que Figma NO importa del SVG:** las conexiones de prototipo. Hay que dibujarlas a mano una vez — son 15 y toma unos minutos.

> Si preferís importar el HTML, existe el plugin **html.to.design**. Sirve, pero trae las pantallas **aplanadas como imagen**: perdés las capas editables. Para trabajar en Figma, importá los SVG.

---

## Cómo probarlo con otra persona

1. Abrí `prototipo.html`, dejalo en la pantalla 01 y **no expliques nada**.
2. Dale una tarea, no una instrucción: *"Necesitás salir el viernes con menos de Bs 40. Mandale una opción a tu grupo."*
3. **Observá y anotá lo que hace**, no lo que opina. Las preguntas van después, nunca durante.
4. Registrá al menos una observación con el formato de la clase: **Antes · Cambio · Después · Siguiente**.

Qué mirar:

- ¿Sabe dónde empieza?
- ¿Reconoce el precio sin abrir el evento?
- ¿Distingue la acción principal?
- ¿Entiende qué pasó después de tocarla?
- ¿Busca algo en un lugar donde no está?

---

## Límites de esta versión

- **Ninguna pantalla fue probada todavía con una persona.** La jerarquía es una hipótesis, no un resultado.
- **Sin estados de error:** lista vacía, sin conexión, evento cancelado.
- **Sin imagen ni flyer** en la tarjeta. Sigue abierta la pregunta de si hace falta.
- **"Me interesa" no navega**, cambia de estado. En el prototipo se muestra como aviso porque no hay una segunda pantalla para eso.
- El contador de interesados **ya funciona en el MVP**, con un identificador local de dispositivo (`FR-07`). Es una decisión del equipo: `OQ-1` sigue abierta hasta probarlo con usuarios.

---

## Historial de versiones

| Versión | Fecha | Cambios |
|---|---|---|
| v0.1 | 27/08/2026 | Primeros wireframes: 6 pantallas de los dos flujos, escala de espaciado base 8 y prototipo con vistas enlazadas |
