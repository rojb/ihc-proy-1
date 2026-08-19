# Flujo v0.1 — Flujo principal

**Proyecto:** App de eventos en Santa Cruz de la Sierra
**Versión:** 0.1
**Fecha:** 18/08/2026
**Persona:** Camila — `persona/persona-v0.1.md`
**App map:** `app-map/app-map-v0.1.md`

> Una tarea, un flujo principal. Este es el **camino normal**. Errores y casos especiales se ven después.

---

## Tarea

**Compartir al grupo un evento con todos los datos para poder decidir.**

Es el medio concreto por el que Camila alcanza su objetivo real: llegar a un plan acordado.

---

## Flujo

```
Abrir la app → Ver eventos de este fin de semana → Filtrar por precio y distancia
   → Comparar tarjetas → Abrir un evento → Compartir al grupo → Ver el mensaje enviado
```

| # | Paso | Qué hace la persona | Qué muestra el sistema |
|---|---|---|---|
| **Inicio** | Abre la app | Jueves por la noche, quiere armar el plan del finde | Lista de eventos vigentes ordenada por fecha y cercanía |
| 1 | Filtra | Toca "este fin de semana" y ajusta precio/distancia | Lista reducida a lo que entra en su presupuesto y zona |
| 2 | Compara | Recorre la lista sin abrir nada | Tarjetas con nombre, **precio**, fecha/hora y distancia |
| 3 | Verifica | Abre el evento que más le convence | Detalle: descripción breve, ubicación con referencia, estado de vigencia |
| 4 | Comparte | Toca "Compartir al grupo" y elige el chat | Mensaje ya armado: nombre, fecha/hora, precio, lugar y enlace |
| **Resultado** | — | El evento está en el chat con los datos completos | Confirmación de que se compartió |

---

## Inicio, acción y resultado

- **Inicio:** Camila quiere salir el fin de semana y todavía no tiene plan.
- **Acción en cada paso:** reducir opciones (filtrar), compararlas con los mismos datos, verificar una y mandarla.
- **Resultado esperado:** el grupo recibe **una opción completa** —qué, cuándo, cuánto, dónde— sin que nadie tenga que buscar el dato faltante. Camila sabe que terminó cuando ve el mensaje en el chat.

El acuerdo del grupo y la llegada al lugar ocurren **fuera de la app**. El flujo termina donde termina lo que la app controla.

---

## Qué NO cubre este flujo (se ve después)

- No hay eventos que cumplan los filtros.
- El evento se cancela o cambia después de compartido.
- Sin conexión o red inestable.
- La persona quiere guardar el evento para más tarde.
- Flujo del organizador (publicar, editar, cancelar): es **otra tarea**, con su propio flujo en la próxima versión.

---

## Preguntas pendientes

1. ¿Qué datos exactos necesita el mensaje compartido para que nadie vuelva a preguntar? ¿Tarjeta, enlace o texto redactado?
2. ¿La comparación se resuelve realmente en la lista, o el usuario abre igual varios detalles?
3. ¿Cómo se comunica la vigencia sin que el usuario tenga que interpretarla?
4. ¿Hace falta un paso de "comparar 2 o 3 seleccionados" antes de compartir?

---

## Primera funcionalidad para el MVP

Del flujo, el paso que sostiene todo lo demás es el **paso 2**:

> **Lista de eventos vigentes con precio, fecha/hora y distancia visibles en la tarjeta, y una acción de compartir.**

Es lo que implementaremos primero, con datos de prueba.

---

## Historial de versiones

| Versión | Fecha | Cambios |
|---|---|---|
| v0.1 | 18/08/2026 | Primer flujo principal de una sola tarea |
