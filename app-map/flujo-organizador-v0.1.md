# Flujo organizador v0.1 — Publicar y mantener un evento

**Proyecto:** App de eventos en Santa Cruz de la Sierra
**Versión:** 0.1
**Fecha:** 27/08/2026
**Persona:** Marco — `persona/persona-organizador-v0.1.md`
**App map:** `app-map/app-map-v0.1.md`
**Flujo principal:** `app-map/flujo-v0.1.md`

> Segunda tarea del proyecto. El flujo principal cubre a quien busca; este cubre a quien publica.
> Este es el **camino normal**. Errores y casos especiales se ven después.

---

## Tarea

**Publicar un evento y poder actualizarlo desde un solo lugar.**

No es "cargar un evento". La evidencia del brief dice otra cosa: *"Tengo que repetir la información cuando cambia algo."* El dolor del organizador no está en publicar una vez, está en **mantener el dato vigente sin repetir el trabajo en cada canal**.

---

## Quién

Marco, organizador de eventos pequeños. Publica desde el celular, entre otras ocupaciones. Hoy sube una historia a Instagram, la repite en el grupo de WhatsApp y, cuando cambia la hora, tiene que volver a los dos lados.

Ficha completa en `persona/persona-organizador-v0.1.md`.

> **Advertencia:** esta Persona se apoya en **una sola** instancia de la investigación simulada (Instancia 4), frente a las tres que sostienen a Camila. Es la parte más débilmente respaldada del proyecto.

---

## Flujo

```
Abrir Publicar → Completar el formulario corto → Publicar
   → El evento aparece en la lista → Mis eventos
   → Cambió algo → Editar → El cambio se ve en un solo lugar
```

| # | Paso | Qué hace la persona | Qué muestra el sistema |
|---|---|---|---|
| **Inicio** | Abre Publicar | Martes a la tarde, quiere anunciar el show del jueves | Formulario corto, vacío, con los campos mínimos a la vista |
| 1 | Carga los datos | Nombre, fecha/hora, **precio**, lugar y una descripción breve | Los mismos campos que la tarjeta necesita para poder compararse |
| 2 | Publica | Toca "Publicar" | El evento queda visible en la lista, marcado como vigente |
| 3 | Verifica | Ve cómo quedó su evento | La tarjeta tal como la ve quien busca |
| 4 | Vuelve más tarde | Entra a "Mis eventos" | Sus eventos, con estado de vigencia e **interesados** |
| 5 | **Actualiza** | Cambió la hora: toca "Editar" y corrige | El cambio queda aplicado y el evento se marca como actualizado |
| **Resultado** | — | El dato correcto está en un solo lugar y no tuvo que repetirlo | Confirmación del cambio |

**El paso 5 es el que justifica la app.** Los pasos 1 a 3 los resuelve Instagram igual de bien; el 5 no.

---

## Inicio, acción y resultado

- **Inicio:** Marco tiene un evento y hoy lo anuncia en canales que no puede corregir sin repetir el trabajo.
- **Acción en cada paso:** cargar una sola vez los datos que quien busca necesita para comparar, y poder corregirlos después desde el mismo lugar.
- **Resultado esperado:** el evento está publicado con precio, fecha/hora y lugar visibles, y cualquier cambio se hace **una vez**. Marco sabe que terminó cuando ve su tarjeta como la ve Camila.

La difusión sigue ocurriendo **fuera de la app**: Marco puede seguir usando Instagram. Lo que la app aporta es un lugar donde el dato se corrige una sola vez.

---

## Por qué el formulario es corto

- **Pide exactamente lo que la tarjeta necesita para compararse**: nombre, precio, fecha/hora, lugar. Ni un campo más.
- **Si publicar cuesta más que armar una historia de Instagram, no lo va a usar.** Es una condición del brief, no una preferencia estética.
- **La descripción es breve y opcional.** El detalle sirve para verificar antes de compartir, no para contar la historia del lugar.
- **El estado de vigencia lo calcula el sistema**, no lo declara el organizador: si dependiera de que él lo marque, volvemos al problema original.

---

## Qué NO cubre este flujo (se ve después)

- Cancelar un evento y avisar a quienes marcaron interés.
- Eventos recurrentes: el show de **todos** los jueves.
- Un evento con varias fechas o varios precios por tipo de entrada.
- Sin conexión: qué pasa con una publicación a medio cargar.
- Quién puede editar un evento: si hace falta cuenta o alcanza un enlace.
- Subir imagen o flyer.
- Qué ve el organizador además del número de interesados.

---

## Preguntas pendientes

1. ¿Cuántos campos tolera Marco antes de abandonar la publicación?
2. ¿Cómo se identifica al organizador para editar? ¿Cuenta o enlace de edición? *(La misma pregunta abierta que bloquea el contador de "Me interesa" en el flujo principal.)*
3. ¿Cómo se comunica que un evento fue actualizado, sin que sea ruido en la tarjeta?
4. ¿Qué pasa con quienes marcaron interés cuando cambia la hora o el precio?
5. ¿Publicar acá le ahorra trabajo real, o le agrega un canal más a los que ya mantiene? **Es la hipótesis central de este flujo y no está validada.**
6. ¿El organizador necesita ver su evento como lo ve quien busca, o le alcanza con la confirmación?

---

## Primera funcionalidad para el MVP

De este flujo, el paso que sostiene el resto es el **paso 5**:

> **Editar un evento ya publicado y que el cambio quede reflejado en la lista.**

Publicar sin poder corregir no resuelve el problema que la evidencia describe. Se implementa junto con un formulario mínimo de creación, con datos de prueba.

---

## Relación con el flujo principal

```
Marco publica ──► El evento entra a la lista ──► Camila lo compara y lo comparte
     ▲                                                        │
     └────────── Interesados en "Mis eventos" ◄───────────────┘
```

Los dos flujos se cierran entre sí: sin publicación no hay lista que comparar, y sin gente que compare no hay señal que le sirva al organizador.

---

## Historial de versiones

| Versión | Fecha | Cambios |
|---|---|---|
| v0.1 | 27/08/2026 | Primer flujo del organizador: publicar y actualizar un evento |
