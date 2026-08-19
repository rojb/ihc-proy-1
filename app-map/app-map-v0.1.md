# App map v0.1

**Proyecto:** App de eventos en Santa Cruz de la Sierra
**Versión:** 0.1
**Fecha:** 18/08/2026
**Persona:** Camila — ver `persona/persona-v0.1.md`

> Pregunta que responde este mapa: **¿dónde puede encontrar Camila lo que necesita?**
> Todavía **no** es un wireframe, ni un prototipo, ni un sistema de diseño. Solo organiza espacios y contenidos principales.

---

## Mapa

| Sección | Contenidos principales |
|---|---|
| **Inicio · Eventos** | Lista de eventos vigentes → Tarjeta de evento (nombre, **precio**, fecha/hora, distancia/zona) · Filtros (hoy / este finde, precio, distancia) |
| **Detalle del evento** | Datos completos → Descripción breve · Ubicación con referencia · Estado de vigencia · **Compartir al grupo** |
| **Publicar** *(organizador)* | Crear evento (formulario corto) · Mis eventos → Editar / Cancelar |

### Como recorrido

```
Inicio · Eventos
├── Filtros ─────────────► Lista filtrada
├── Tarjeta de evento ───► Detalle del evento
│                          ├── Ubicación (abrir mapa externo)
│                          └── Compartir ──► WhatsApp (fuera de la app)
└── Publicar
    ├── Crear evento
    └── Mis eventos ─────► Editar / Cancelar
```

**Camino de la tarea principal:**
`Inicio → Lista → Tarjeta → Detalle → Compartir`

---

## Por qué está organizado así

- **La lista es la pantalla principal, no un buscador.** La evidencia dice que el problema es comparar, no encontrar: la comparación tiene que pasar en la lista, sin abrir cada evento.
- **El precio vive en la tarjeta, no en el detalle.** Es dato de descarte; si obliga a entrar, la comparación se rompe.
- **Compartir es una acción del evento**, no una sección aparte: es el final natural del flujo.
- **Publicar es una rama separada.** Es otro usuario y otra tarea; no debe mezclarse con el descubrimiento.
- **La app no intenta reemplazar a WhatsApp ni al mapa.** El acuerdo del grupo y la navegación ocurren afuera, y el mapa lo refleja.

---

## Alcance de la primera versión

### Usaremos

`Inicio · Eventos → Tarjeta con precio/fecha/distancia → Detalle → Compartir al grupo`

Más el mínimo del lado del organizador: `Publicar → Crear evento → Editar / Cancelar`.

| Entra | Motivo |
|---|---|
| Lista de eventos vigentes | Es donde ocurre la comparación |
| Precio, fecha/hora, ubicación o distancia visibles en la tarjeta | Datos de decisión según la evidencia |
| Indicador de vigencia | Problema detectado en instancias 1 y 2 |
| Filtros básicos: fecha, precio, distancia | Reducen opciones antes del grupo |
| Detalle del evento | Verificación antes de compartir |
| Compartir a WhatsApp con el mensaje ya armado | Cierra la tarea central |
| Publicación simple + editar/cancelar | Sin eventos no hay lista |

### Dejaremos fuera

Cuentas y perfiles sociales, seguidores, chat dentro de la app, compra o venta de entradas, recomendaciones personalizadas, analítica avanzada para organizadores, publicidad, integración automática con redes sociales, navegación o transporte propios, notificaciones push.

---

## Preguntas pendientes

1. ¿La tarjeta necesita imagen o alcanza con texto? (afecta cuántos eventos se comparan de un vistazo)
2. ¿Distancia exacta o referencia de zona?
3. ¿Cómo se muestra "actualizado recientemente" sin agregar ruido a la tarjeta?
4. ¿"Mis eventos" necesita cuenta o alcanza con un enlace de edición?

---

## Historial de versiones

| Versión | Fecha | Cambios |
|---|---|---|
| v0.1 | 18/08/2026 | Primer mapa derivado del Brief v0.2.0 y de la Persona v0.1 |
