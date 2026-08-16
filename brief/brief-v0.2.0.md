# Brief v0.2.0

**Proyecto:** App de eventos en Santa Cruz de la Sierra  
**Versión:** 0.2.0  
**Fecha:** 16/08/2026  
**Estado:** Hipótesis revisada mediante investigación simulada con IA

> **Nota:** la investigación utilizada para esta versión corresponde a 4 entrevistas simuladas mediante instancias de IA. Estas evidencias permiten explorar y ajustar el brief, pero no sustituyen la validación con usuarios reales.

## 1. Problema revisado

Las personas que quieren salir en Santa Cruz tienen dificultades para convertir información dispersa sobre eventos en un **plan concreto con otras personas**.

La dificultad principal no parece ser simplemente encontrar eventos, sino **comparar rápidamente opciones y decidir en grupo**. Para hacerlo, actualmente deben combinar Instagram, WhatsApp y otras fuentes para verificar datos como precio, fecha/hora y ubicación.

Además, la vigencia de la información puede ser confusa cuando existen publicaciones antiguas o cambios comunicados en otros canales.

Para los organizadores pequeños, aparece una dificultad relacionada: publicar y mantener actualizada la información puede implicar repetir el mismo trabajo en varios canales.

## 2. Evidencia

La investigación simulada produjo cuatro evidencias principales:

- “Si no encuentro rápido el precio, lo dejo de lado.”
- “Terminamos con varias capturas y links.”
- “Cuando estoy decidiendo para esa misma noche no quiero esperar una respuesta.”
- “Tengo que repetir la información cuando cambia algo.”

Estas evidencias apuntan a tres necesidades recurrentes: **comparación rápida, datos esenciales visibles y coordinación sencilla**.

La evidencia completa se encuentra en `research/evidencias.md`.

## 3. Hipótesis revisada

> Si las personas pueden comparar eventos cercanos mostrando de forma inmediata **precio, fecha/hora y ubicación**, y pueden compartir una opción al grupo con poca fricción, podrán llegar a un plan acordado sin tener que saltar constantemente entre varias publicaciones y aplicaciones.

### Lo que creemos ahora

- El precio funciona como criterio de descarte.
- La fecha/hora y la vigencia son fundamentales para evitar opciones incorrectas.
- La ubicación ayuda a reducir opciones antes de discutirlas en grupo.
- WhatsApp continúa siendo un paso importante del proceso de decisión.
- Para organizadores pequeños, la velocidad de publicación y actualización es una condición importante.

### Lo que todavía debemos comprobar

- Si una aplicación dedicada realmente reduce el tiempo total para decidir.
- Qué información mínima debe aparecer en una tarjeta para que no sea necesario abrir el detalle.
- Qué formato de compartir funciona mejor para una conversación grupal.
- Si los organizadores aceptarían publicar directamente en la plataforma.
- Qué mecanismo de actualización permite mantener la vigencia de los eventos.

## 4. Flujo principal

### Flujo de quien busca

1. Abrir la aplicación y ver eventos cercanos/vigentes.
2. Filtrar por fecha, precio o distancia.
3. Comparar rápidamente varias opciones.
4. Abrir una opción para verificar los datos necesarios.
5. Compartir una opción al grupo.
6. El grupo acuerda el plan.
7. Llegar al evento usando la ubicación/mapa.

**Tarea central:** llegar a un plan acordado con otras personas.

## 5. Primer requerimiento

La primera capacidad concreta a diseñar e implementar será:

> **Una lista de eventos que permita comparar rápidamente eventos vigentes mostrando precio, fecha/hora y ubicación/distancia, con una acción directa para compartir el evento.**

La publicación de eventos puede formar parte de la primera versión, pero debe mantenerse como un flujo corto y separado del flujo principal de descubrimiento.

## 6. Usuario y contexto

### Usuario primario

Persona que quiere salir pero todavía no tiene un plan cerrado y necesita comparar opciones con amigos.

### Usuario secundario

Organizador pequeño, como un bar, banda local o colectivo cultural, que publica eventos principalmente desde el celular.

### Contexto

- Jueves y viernes por la noche al planificar el fin de semana.
- Sábado por la tarde cuando se decide algo de último momento.
- Sesiones cortas desde el celular.
- Posible uso con una sola mano.
- Conectividad móvil que puede ser inestable.
- Decisión frecuentemente coordinada mediante WhatsApp.

## 7. Insights

A partir de la v0.1 y de la investigación simulada:

1. **Buscar no es el objetivo final.** El objetivo es conseguir un plan acordado.
2. **La información faltante puede eliminar una opción.** Especialmente el precio.
3. **Comparar es más importante que acumular eventos.** Mostrar muchas opciones sin datos comparables no resuelve el problema.
4. **La vigencia debe ser visible y mantenible.** No basta con mostrar la fecha del evento si la publicación puede estar desactualizada.
5. **El organizador necesita simplicidad.** Agregar un canal nuevo de publicación no debe significar duplicar trabajo.

## 8. Alcance inicial

### Entra en la primera versión

- Listado de eventos.
- Precio visible.
- Fecha y hora visibles.
- Ubicación y/o distancia.
- Indicador de vigencia.
- Filtros básicos por fecha, precio y distancia.
- Vista de detalle.
- Compartir evento mediante WhatsApp.
- Publicación simple para organizadores.
- Edición/cancelación básica de eventos.

### Fuera del alcance inicial

- Sistema avanzado de recomendaciones personalizadas.
- Compra o venta de entradas dentro de la aplicación.
- Chat entre usuarios.
- Sistema social de seguidores.
- Publicidad avanzada para organizadores.
- Analítica avanzada de campañas.
- Integración automática con todas las redes sociales.
- Funciones de navegación o transporte propias de la aplicación.

## 9. Criterios de éxito

1. **Comparación:** una persona puede identificar rápidamente precio, fecha/hora y ubicación de varias opciones sin abrir múltiples fuentes.
2. **Coordinación:** una persona puede compartir un evento al grupo sin copiar manualmente toda la información.
3. **Decisión:** en una prueba posterior, el usuario puede seleccionar una opción y explicar por qué la eligió sin necesitar volver a buscar datos esenciales fuera de la aplicación.

## 10. Preguntas abiertas para la siguiente etapa

1. ¿Qué información debe aparecer obligatoriamente en la tarjeta del evento?
2. ¿La distancia exacta o solamente una referencia de zona es más útil para decidir?
3. ¿Cómo debería mostrarse que un evento fue actualizado recientemente?
4. ¿Los usuarios prefieren compartir una tarjeta, un enlace o un mensaje ya redactado?
5. ¿Qué nivel de confianza necesitan para considerar vigente un evento?
6. ¿Los organizadores aceptarían crear el evento directamente en la aplicación?
7. ¿Qué información mínima necesita un organizador para publicar sin sentir que está haciendo más trabajo que en Instagram?
8. ¿La aplicación reduce realmente el número de pasos y aplicaciones utilizadas frente al método actual?

## 11. Relación con v0.1

La v0.1 planteaba como hipótesis que mostrar **precio, fecha y distancia** en una sola pantalla y compartir en un toque podría acelerar la decisión. fileciteturn0file0L105-L111

La investigación simulada mantiene esa dirección, pero pone más énfasis en que el problema central es **convertir la búsqueda en una decisión grupal**, y añade la vigencia/actualización como aspecto que debe investigarse. La v0.1 ya identificaba que la decisión se toma en el chat del grupo y que el flujo debe poder terminar en WhatsApp. fileciteturn0file0L27-L37

## 12. Historial de versiones

| Versión | Fecha | Cambios |
|---|---|---|
| v0.1 | 13/08/2026 | Versión inicial con hipótesis y preguntas de investigación |
| v0.2.0 | 16/08/2026 | Hipótesis revisada, evidencias simuladas, alcance inicial, criterios de éxito y preguntas abiertas |
