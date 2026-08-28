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
| **Inicio · Eventos** | Lista de eventos vigentes → Tarjeta de evento (nombre, **precio**, fecha/hora, distancia/zona, **interesados**) · Filtros (hoy / este finde, precio, distancia) |
| **Detalle del evento** | Datos completos → Descripción breve · Ubicación con referencia · Estado de vigencia · **Me interesa / Ya no me interesa** con contador · **Compartir al grupo** |
| **Publicar** *(organizador)* | Crear evento (formulario corto) · Mis eventos → **Interesados por evento** · Editar / Cancelar |

### Como recorrido

```
Inicio · Eventos
├── Filtros ─────────────► Lista filtrada
├── Tarjeta de evento ───► Detalle del evento
│    (muestra interesados)  ├── Me interesa ──► Contador +1 (revertible)
│                           ├── Ubicación (abrir mapa externo)
│                           └── Compartir ──► WhatsApp (fuera de la app)
└── Publicar
    ├── Crear evento
    └── Mis eventos ─────► Interesados por evento
                           Editar / Cancelar
```

**Camino de la tarea principal:**
`Inicio → Lista → Tarjeta → Detalle → (Me interesa) → Compartir`

`Me interesa` es **opcional** dentro del camino principal: no bloquea ni condiciona el compartir.

---

## Por qué está organizado así

- **La lista es la pantalla principal, no un buscador.** La evidencia dice que el problema es comparar, no encontrar: la comparación tiene que pasar en la lista, sin abrir cada evento.
- **El precio vive en la tarjeta, no en el detalle.** Es dato de descarte; si obliga a entrar, la comparación se rompe.
- **El contador de interesados vive en la tarjeta por el mismo motivo que el precio.** Si es un dato que influye en la decisión, tiene que estar donde ocurre la comparación. Si solo apareciera en el detalle, no serviría para descartar.
- **La acción "Me interesa" vive en el detalle, no en la tarjeta.** Marcar interés supone haber verificado los datos. Ponerla en la tarjeta abarata la señal y la vuelve ruido.
- **El contador es un número, no una lista de nombres.** Es lo que mantiene la función fuera del "sistema social" que el brief descartó: da señal de demanda sin crear identidad pública.
- **"Me interesa" no es "Voy".** La etiqueta tiene que ser honesta con lo que la app puede sostener: la app no confirma asistencia, y prometerlo destruiría la confianza en el dato.
- **Compartir sigue siendo el cierre del flujo.** El interés acompaña la decisión; no la reemplaza. El acuerdo del grupo sigue ocurriendo en WhatsApp.
- **El organizador ve el interés donde ya administra sus eventos.** No necesita una sección nueva: es un dato de "Mis eventos".
- **Publicar es una rama separada.** Es otro usuario y otra tarea; no debe mezclarse con el descubrimiento.
- **La app no intenta reemplazar a WhatsApp ni al mapa.** El acuerdo del grupo y la navegación ocurren afuera, y el mapa lo refleja.

### Riesgo asumido

Mostrar el contador en la tarjeta introduce **sesgo de popularidad**: los eventos grandes acumulan interés y los chicos quedan enterrados, justamente los organizadores pequeños que el brief identifica como usuario secundario. Es un riesgo aceptado en esta versión y algo a observar en la evaluación con usuarios.

---

## Alcance de la primera versión

### Usaremos

`Inicio · Eventos → Tarjeta con precio/fecha/distancia/interesados → Detalle → Me interesa → Compartir al grupo`

Más el mínimo del lado del organizador: `Publicar → Crear evento → Mis eventos (con interesados) → Editar / Cancelar`.

| Entra | Motivo |
|---|---|
| Lista de eventos vigentes | Es donde ocurre la comparación |
| Precio, fecha/hora, ubicación o distancia visibles en la tarjeta | Datos de decisión según la evidencia |
| **Contador de interesados en la tarjeta** | Señal de demanda disponible durante la comparación |
| Indicador de vigencia | Problema detectado en instancias 1 y 2 |
| Filtros básicos: fecha, precio, distancia | Reducen opciones antes del grupo |
| Detalle del evento | Verificación antes de compartir |
| **Acción "Me interesa" revertible** | Permite corregir sin costo; un interés que no se puede retirar deja de ser información confiable |
| **Identificación liviana** (solo para no contar dos veces a la misma persona) | Sin ella el contador no significa nada |
| **Interesados visibles en "Mis eventos"** | Cierra el valor para el organizador |
| Compartir a WhatsApp con el mensaje ya armado | Cierra la tarea central |
| Publicación simple + editar/cancelar | Sin eventos no hay lista |

### Dejaremos fuera

Perfiles públicos, lista de nombres de interesados, seguidores, chat dentro de la app, compra o venta de entradas, confirmación de asistencia real, recomendaciones personalizadas, analítica avanzada para organizadores, publicidad, integración automática con redes sociales, navegación o transporte propios, notificaciones push.

> **Nota de coherencia:** el Brief v0.2.0 ya registra este cambio. Lo que queda fuera del alcance social son los perfiles públicos, los seguidores, la lista visible de nombres de interesados y la confirmación de asistencia real. El contador de interesados es una señal pública, pero anónima: muestra un número, no personas.

---

## Preguntas pendientes

1. ¿La tarjeta necesita imagen o alcanza con texto? (afecta cuántos eventos se comparan de un vistazo)
2. ¿Distancia exacta o referencia de zona?
3. ¿Cómo se muestra "actualizado recientemente" sin agregar ruido a la tarjeta?
4. ¿"Mis eventos" necesita cuenta o alcanza con un enlace de edición?
5. ~~¿Qué identificación mínima necesita "Me interesa"?~~ **Decidido en el MVP:** identificador local de dispositivo, sin cuentas (`FR-07`). Queda por comprobar con usuarios si el contador resiste, porque alguien puede inflarlo reinstalando (`OQ-1`, riesgo `R-6`).
6. ¿Desde qué número el contador aporta y desde cuál desinforma? Un evento con 2 interesados, ¿muestra "2" o no muestra nada?
7. ¿El contador ayuda a decidir o solo copia lo que ya se sabe? Hay que comprobar que no sea decorativo.
8. ¿Cómo se evita que el sesgo de popularidad entierre a los organizadores pequeños?
9. ¿El interés se incluye en el mensaje compartido a WhatsApp?

---

## Historial de versiones

| Versión | Fecha | Cambios |
|---|---|---|
| v0.1 | 18/08/2026 | Primer mapa derivado del Brief v0.2.0 y de la Persona v0.1. Incluye la acción "Me interesa" con contador público |
