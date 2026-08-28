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
- Una señal pública de interés puede aportar un criterio más de comparación y darle al organizador una medida de convocatoria. **El respaldo es desparejo y hay que decirlo con precisión:** el lado del organizador tiene apoyo parcial —la Instancia 4 declara que hoy mide el resultado viendo "las respuestas, mensajes y personas que preguntan"—, pero **el lado de la comparación no tiene ninguno**: ninguna instancia menciona el interés ajeno como criterio para elegir un evento.

### Lo que todavía debemos comprobar

- Si una aplicación dedicada realmente reduce el tiempo total para decidir.
- Qué información mínima debe aparecer en una tarjeta para que no sea necesario abrir el detalle.
- Qué formato de compartir funciona mejor para una conversación grupal.
- Si los organizadores aceptarían publicar directamente en la plataforma.
- Qué mecanismo de actualización permite mantener la vigencia de los eventos.
- Si un contador de interesados influye realmente en la decisión o solo confirma lo que la persona ya había elegido.
- Si el identificador local de dispositivo alcanza para que el contador sea confiable. El MVP ya lo implementó así (`FR-07`), pero es una decisión del equipo: falta comprobar con usuarios si el dato resiste, sabiendo que alguien puede inflarlo reinstalando (riesgo `R-6`).

## 4. Flujo principal

### Flujo de quien busca

1. Abrir la aplicación y ver eventos cercanos/vigentes.
2. Filtrar por fecha, precio o distancia.
3. Comparar rápidamente varias opciones, incluyendo cuántas personas marcaron interés.
4. Abrir una opción para verificar los datos necesarios.
5. Marcar "Me interesa" *(opcional)*: contar públicamente que quiere participar. No bloquea el paso siguiente.
6. Compartir una opción al grupo.
7. El grupo acuerda el plan.
8. Llegar al evento usando la ubicación/mapa.

### Efecto hacia el organizador

El interés marcado en el paso 5 llega al organizador dentro de "Mis eventos", sin que la persona tenga que hacer nada más. Le sirve para dimensionar la convocatoria, pero **no es una confirmación de asistencia**.

**Tarea central:** llegar a un plan acordado con otras personas.

## 5. Primer requerimiento

La primera capacidad concreta a diseñar e implementar será:

> **Una lista de eventos que permita comparar rápidamente eventos vigentes mostrando precio, fecha/hora y ubicación/distancia, con una acción directa para compartir el evento.**

La publicación de eventos puede formar parte de la primera versión, pero debe mantenerse como un flujo corto y separado del flujo principal de descubrimiento.

La acción **"Me interesa" con contador público** forma parte de la primera versión y **ya está implementada** en `proy-1-mvp/` (`FR-08`, `FR-09`). Para que el contador no cuente dos veces a la misma persona, el MVP usa un identificador local de dispositivo, generado al primer uso, sin registro ni datos personales (`FR-07`). **Es una decisión del equipo, no una respuesta validada:** `OQ-1` sigue abierta en el PRD.

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
6. **Una señal de interés puede servir a las dos puntas.** A quien compara le agrega un criterio; al organizador le da una medida de convocatoria. El riesgo es el **sesgo de popularidad**: los eventos grandes acumulan interés y pueden enterrar a los organizadores pequeños, que son justamente el usuario secundario de este proyecto.

## 8. Alcance inicial

### Entra en la primera versión

- Listado de eventos.
- Precio visible.
- Fecha y hora visibles.
- Ubicación y/o distancia.
- Indicador de vigencia.
- Filtros básicos por fecha, precio y distancia.
- Vista de detalle.
- Acción "Me interesa" revertible, con **contador público de interesados** (solo el número, nunca una lista de nombres).
- Interesados visibles para el organizador dentro de "Mis eventos".
- Identificación liviana, con el único fin de no contar dos veces a la misma persona.
- Compartir evento mediante WhatsApp.
- Publicación simple para organizadores.
- Edición/cancelación básica de eventos.

### Fuera del alcance inicial

- Sistema avanzado de recomendaciones personalizadas.
- Compra o venta de entradas dentro de la aplicación.
- Chat entre usuarios.
- Perfiles públicos, seguidores y lista visible de nombres de interesados.
- Confirmación de asistencia real: "Me interesa" no es "Voy", y la aplicación no verifica quién asistió.
- Publicidad avanzada para organizadores.
- Analítica avanzada de campañas.
- Integración automática con todas las redes sociales.
- Funciones de navegación o transporte propias de la aplicación.

## 9. Criterios de éxito

1. **Comparación:** una persona puede identificar rápidamente precio, fecha/hora y ubicación de varias opciones sin abrir múltiples fuentes.
2. **Coordinación:** una persona puede compartir un evento al grupo sin copiar manualmente toda la información.
3. **Decisión:** en una prueba posterior, el usuario puede seleccionar una opción y explicar por qué la eligió sin necesitar volver a buscar datos esenciales fuera de la aplicación.
4. **Señal de interés:** una persona puede contar que le interesa participar en un solo toque y deshacerlo sin costo, y entiende que eso no es una confirmación de asistencia.

## 10. Preguntas abiertas para la siguiente etapa

1. ¿Qué información debe aparecer obligatoriamente en la tarjeta del evento?
2. ¿La distancia exacta o solamente una referencia de zona es más útil para decidir?
3. ¿Cómo debería mostrarse que un evento fue actualizado recientemente?
4. ¿Los usuarios prefieren compartir una tarjeta, un enlace o un mensaje ya redactado?
5. ¿Qué nivel de confianza necesitan para considerar vigente un evento?
6. ¿Los organizadores aceptarían crear el evento directamente en la aplicación?
7. ¿Qué información mínima necesita un organizador para publicar sin sentir que está haciendo más trabajo que en Instagram?
8. ¿La aplicación reduce realmente el número de pasos y aplicaciones utilizadas frente al método actual?
9. ¿El identificador local de dispositivo alcanza para que el contador sea confiable? El MVP lo implementó así; falta comprobarlo con usuarios (`OQ-1`).
10. ¿Desde qué número el contador aporta información y desde cuál desinforma? ¿Un evento con 2 interesados muestra "2" o no muestra nada?
11. ¿"Me interesa" es la etiqueta correcta, o el usuario espera "Voy" y le atribuye un compromiso que la aplicación no sostiene?
12. ¿Cómo se evita que el sesgo de popularidad entierre a los organizadores pequeños?

## 11. Relación con v0.1

La v0.1 planteaba como hipótesis que mostrar **precio, fecha y distancia** en una sola pantalla y compartir en un toque podría acelerar la decisión. fileciteturn0file0L105-L111

La investigación simulada mantiene esa dirección, pero pone más énfasis en que el problema central es **convertir la búsqueda en una decisión grupal**, y añade la vigencia/actualización como aspecto que debe investigarse. La v0.1 ya identificaba que la decisión se toma en el chat del grupo y que el flujo debe poder terminar en WhatsApp. fileciteturn0file0L27-L37

## 12. Historial de versiones

| Versión | Fecha | Cambios |
|---|---|---|
| v0.1 | 13/08/2026 | Versión inicial con hipótesis y preguntas de investigación |
| v0.2.0 | 16/08/2026 | Hipótesis revisada, evidencias simuladas, alcance inicial, criterios de éxito y preguntas abiertas |
| v0.2.0 | 19/08/2026 | Se incorpora la acción "Me interesa" con contador público: entra al alcance inicial, al flujo principal, a los insights, a los criterios de éxito y a las preguntas abiertas. Se precisa qué queda fuera del alcance social: perfiles, seguidores, nombres de interesados y confirmación de asistencia |
