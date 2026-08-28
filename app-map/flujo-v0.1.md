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

En el camino puede además **contar que le interesa participar**, dejando una señal pública que sirve a quienes comparan después y al organizador.

---

## Flujo

```
Abrir la app → Ver eventos de este fin de semana → Filtrar por precio y distancia
   → Comparar tarjetas (precio + interesados) → Abrir un evento
   → Marcar "Me interesa" → Compartir al grupo → Ver el mensaje enviado
```

| # | Paso | Qué hace la persona | Qué muestra el sistema |
|---|---|---|---|
| **Inicio** | Abre la app | Jueves por la noche, quiere armar el plan del finde | Lista de eventos vigentes ordenada por fecha y cercanía |
| 1 | Filtra | Toca "este fin de semana" y ajusta precio/distancia | Lista reducida a lo que entra en su presupuesto y zona |
| 2 | Compara | Recorre la lista sin abrir nada | Tarjetas con nombre, **precio**, fecha/hora, distancia e **interesados** |
| 3 | Verifica | Abre el evento que más le convence | Detalle: descripción breve, ubicación con referencia, estado de vigencia, interesados |
| 4 | **Cuenta que le interesa** *(opcional)* | Toca **"Me interesa"** | El contador sube y el botón queda marcado; puede deshacerlo |
| 5 | Comparte | Toca "Compartir al grupo" y elige el chat | Mensaje ya armado: nombre, fecha/hora, precio, lugar y enlace |
| **Resultado** | — | El evento está en el chat con los datos completos y ella ya dejó su señal | Confirmación de que se compartió |

**El paso 4 no bloquea el 5.** Si Camila no marca nada, el flujo se completa igual.

---

## Inicio, acción y resultado

- **Inicio:** Camila quiere salir el fin de semana y todavía no tiene plan.
- **Acción en cada paso:** reducir opciones (filtrar), compararlas con los mismos datos, verificar una, **dejar constancia de su interés** y mandarla al grupo.
- **Resultado esperado:** el grupo recibe **una opción completa** —qué, cuándo, cuánto, dónde— sin que nadie tenga que buscar el dato faltante. Camila sabe que terminó cuando ve el mensaje en el chat. Además, su interés queda contabilizado para las próximas personas que comparen y para el organizador.

El acuerdo del grupo y la llegada al lugar ocurren **fuera de la app**. El flujo termina donde termina lo que la app controla.

---

## Efecto secundario: el organizador

No es un flujo nuevo, es una consecuencia del paso 4.

```
Organizador → Publicar → Mis eventos → Ve cuántas personas marcaron interés
```

Le sirve para dimensionar la convocatoria. **No es una confirmación de asistencia**, y hay que decirlo con esas palabras: si el organizador lo interpreta como gente confirmada, la señal le hace más daño que bien.

---

## Qué NO cubre este flujo (se ve después)

- No hay eventos que cumplan los filtros.
- El evento se cancela o cambia después de compartido, **o después de que alguien marcó interés**.
- Sin conexión o red inestable: **el "Me interesa" queda pendiente de sincronizar**.
- La persona quiere guardar el evento para más tarde (guardar ≠ interesar: son intenciones distintas).
- **Alguien marca interés y después no va.** La app no lo verifica ni lo penaliza.
- **Un evento con cero interesados.** Hay que decidir si se muestra "0" o no se muestra nada.
- Flujo del organizador (publicar, editar, cancelar): es **otra tarea**, y tiene su propio documento en `app-map/flujo-organizador-v0.1.md`.

---

## Preguntas pendientes

1. ¿Qué datos exactos necesita el mensaje compartido para que nadie vuelva a preguntar? ¿Tarjeta, enlace o texto redactado?
2. ¿La comparación se resuelve realmente en la lista, o el usuario abre igual varios detalles?
3. ¿Cómo se comunica la vigencia sin que el usuario tenga que interpretarla?
4. ¿Hace falta un paso de "comparar 2 o 3 seleccionados" antes de compartir?
5. ¿El paso 4 va antes o después de compartir? Aquí quedó antes, asumiendo que Camila decide y luego difunde. Habría que comprobar si en la práctica marca interés recién cuando el grupo respondió.
6. ¿"Me interesa" es la etiqueta correcta? ¿O el usuario espera "Voy" / "Me sumo" y le atribuye un compromiso que la app no sostiene?
7. ¿El contador cambia lo que Camila elige, o solo confirma lo que ya había decidido? Si no cambia nada, es peso muerto en la tarjeta.
8. ¿Qué pasa con el interés cuando el evento se cancela? ¿Se avisa a quienes marcaron?

---

## Primera funcionalidad para el MVP

Del flujo, el paso que sostiene todo lo demás es el **paso 2**:

> **Lista de eventos vigentes con precio, fecha/hora y distancia visibles en la tarjeta, y una acción de compartir.**

Es lo que implementaremos primero, con datos de prueba.

El **paso 4 ("Me interesa" con contador) ya está implementado** en `proy-1-mvp/` (`FR-08`, `FR-09`). Para no contar dos veces a la misma persona se usa un identificador local de dispositivo (`FR-07`), decidido por el equipo y todavía sin validar con usuarios (`OQ-1`).

---

## Historial de versiones

| Versión | Fecha | Cambios |
|---|---|---|
| v0.1 | 18/08/2026 | Primer flujo principal de una sola tarea, con el paso opcional "Me interesa" |
