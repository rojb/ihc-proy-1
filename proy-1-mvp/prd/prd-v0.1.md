# PRD v0.1 — MVP · App de eventos en Santa Cruz de la Sierra

**Estado:** Borrador
**Autores:** Ruben Orestes Justiniano Becerra (216163501) · Faryd Lucas Soliz Marquez (221045880)
**Fecha:** 19/08/2026
**Versión:** 0.1

**Documentos base:** `ihc-proy-1/brief/brief-v0.2.0.md` · `ihc-proy-1/persona/persona-v0.1.md` · `ihc-proy-1/app-map/app-map-v0.1.md` · `ihc-proy-1/app-map/flujo-v0.1.md` · `ihc-proy-1/research/evidencias.md`

> **Aviso metodológico (aplica a todo el documento).** La evidencia disponible proviene de **4 entrevistas simuladas con instancias de IA**, no de usuarios reales. Todo requisito marcado como "respaldado por evidencia" está respaldado por evidencia *simulada*: sirve para orientar el diseño, no para darlo por validado. Las métricas de la sección 3 son **objetivos a medir**, no valores observados. Ninguna hipótesis de este PRD fue validada con personas reales todavía.

---

## 1. Overview

Aplicación móvil que reúne en una sola lista los eventos vigentes de Santa Cruz de la Sierra mostrando, en la misma tarjeta, los cuatro datos con los que la gente decide: **qué, cuándo, cuánto y dónde**. Está pensada para quien quiere salir y todavía no tiene plan cerrado, y necesita comparar opciones y llevarle una al grupo de WhatsApp sin armar el mensaje a mano. Como usuario secundario contempla al organizador pequeño, que publica desde el celular y necesita una forma rápida de crear, corregir y dimensionar la convocatoria de sus eventos.

---

## 2. Problem Statement

> Esta sección describe el problema. No propone solución.

### Estado actual

Para decidir a qué evento ir, una persona en Santa Cruz recorre hoy un circuito manual: descubre una opción en historias de Instagram o en un flyer reenviado, no encuentra el precio, busca en otra publicación o en los comentarios, verifica si la fecha sigue vigente, manda una captura al grupo de WhatsApp, y ahí otra persona termina de buscar los datos que faltaban. El acuerdo se cocina en el chat, con capturas sueltas y links que no traen la misma información.

Del otro lado, el organizador pequeño publica el mismo evento en Instagram y WhatsApp, responde por privado datos que ya estaban en el flyer, y cuando cambia la hora o el precio tiene que actualizar cada canal por separado.

### Impacto

| A quién | Con qué frecuencia | Qué le cuesta |
|---|---|---|
| Persona que busca plan | Jueves/viernes por la noche al armar el finde; sábado por la tarde cuando decide de último momento | Tiempo y saltos entre 2+ aplicaciones; **opciones que se descartan por falta de dato, no por falta de interés**; riesgo de compartir un evento no vigente |
| Grupo que decide | En cada plan | Conversación llena de capturas y preguntas de datos faltantes; la ventana de decisión (misma noche) no tolera esperar respuestas |
| Organizador pequeño | En cada publicación y en cada cambio | Trabajo duplicado por canal; consultas repetidas; no sabe si la publicación convocó |

### Causa raíz

1. **La información nace fragmentada y sin formato común.** Cada publicación decide qué datos incluye, así que las opciones no son comparables entre sí.
2. **No existe una noción de vigencia.** Una historia vieja se ve igual que una vigente, y el cambio se comunica en un canal distinto al del anuncio original.
3. **El canal de descubrimiento (Instagram) y el canal de decisión (WhatsApp) están desconectados**, y el trasvase entre ambos es manual.
4. **Publicar bien cuesta más que publicar rápido**, y el organizador optimiza por rapidez.

> Frase que resume el problema, tomada de la Persona: *"Si en 10 segundos no sé cuánto cuesta y dónde es, no lo mando al grupo."*

---

## 3. Goals & Success Metrics

### Objetivo

Que una persona pueda pasar de *"quiero salir este finde"* a *"esta opción está en el chat del grupo, con todos los datos"* **sin salir de la aplicación a buscar información faltante**.

### Key Results

Se miden en una **prueba de usabilidad moderada con usuarios reales** (n ≥ 5 por perfil), con la tarea: *"Elegí un evento para este fin de semana y compartilo con tu grupo"*. No son métricas de producción: el MVP corre con datos de prueba.

| # | Métrica | Baseline | Objetivo | Cuándo | Responsable |
|---|---|---|---|---|---|
| KR1 | Tasa de éxito de la tarea sin ayuda del moderador | No medido | ≥ 80 % de los participantes | Evaluación con usuarios | Equipo |
| KR2 | Tiempo desde abrir la app hasta ver el mensaje compartido | No medido (el método actual se mide como tarea de control en la misma sesión) | Mediana ≤ 90 s, **y menor que la tarea de control** | Evaluación con usuarios | Equipo |
| KR3 | Fuentes externas consultadas antes de compartir | 2+ hoy (Instagram + WhatsApp, según evidencia simulada) | 0 | Evaluación con usuarios | Equipo |
| KR4 | Participantes que descartan ≥ 1 opción **sin abrir el detalle** (prueba de que la comparación ocurre en la lista) | No medido | ≥ 60 % | Evaluación con usuarios | Equipo |
| KR5 | Datos faltantes en el mensaje compartido (checklist: qué / cuándo / cuánto / dónde) | 1+ hoy (el grupo repregunta) | 0 | Evaluación con usuarios | Equipo |
| KR6 | Participantes que, al describir "Me interesa", dicen que **no** es una confirmación de asistencia | No medido | ≥ 80 % | Evaluación con usuarios | Equipo |
| KR7 | Organizadores que publican un evento completo sin ayuda | No medido | ≥ 80 %, en ≤ 120 s | Evaluación con usuarios | Equipo |

### Anti-objetivos

Qué **no** cuenta como éxito, aunque las métricas suban:

- **Más tiempo dentro de la app.** El flujo termina en WhatsApp: si la persona se queda navegando, no la ayudamos a decidir.
- **Más eventos listados.** Acumular opciones sin datos comparables reproduce el problema actual.
- **Más interés marcado.** El contador es una señal de comparación, no una métrica de vanidad; inflarlo lo vuelve ruido.
- **Retención o frecuencia de uso.** El uso natural es de 1–2 sesiones cortas por semana.
- **Que la app reemplace a WhatsApp o al mapa.** El acuerdo del grupo y la navegación ocurren afuera, a propósito.

---

## 4. User Personas

### Persona primaria — Camila

Ver ficha completa en `ihc-proy-1/persona/persona-v0.1.md`.

- **Contexto:** 22 años, estudiante en Santa Cruz de la Sierra. Revisa el celular jueves/viernes por la noche, en la cama o en el bus. Sale casi siempre con el mismo grupo; la decisión se cocina en el grupo de WhatsApp. Presupuesto ajustado.
- **Objetivo:** llegar a un plan acordado con su grupo para este fin de semana: un evento concreto con hora, lugar y precio que todos acepten.
- **Dolores:** el precio no aparece y descarta en vez de averiguar; no distingue lo vigente de una publicación vieja; termina mandando capturas sueltas al grupo.
- **Nivel técnico:** intermedio. Usuaria fluida de Instagram y WhatsApp; sin tolerancia a registros ni formularios para tareas de consumo.
- **Supuestos sin respaldo:** edad, condición de estudiante, presupuesto y el momento jueves/viernes son plausibles pero **no** salen de la evidencia.

### Persona secundaria — Organizador pequeño

- **Contexto:** bar, banda local o colectivo cultural. Publica desde el celular, principalmente en Instagram y WhatsApp.
- **Objetivo:** que la gente se entere y venga, sin repetir el mismo trabajo en cada canal.
- **Dolores:** actualizar la información en varios lugares cuando algo cambia; responder consultas de datos que ya publicó; no saber si la publicación convocó.
- **Por qué es secundario:** sin gente decidiendo planes, publicar no tiene valor. Su flujo entra al MVP en su forma mínima, no como experiencia completa.

---

## 5. User Stories / Jobs to be Done

| # | Job to be Done | Persona | Prioridad |
|---|---|---|---|
| JTBD-1 | **Cuando** quiero salir el finde y todavía no tengo plan, **quiero** ver de un vistazo qué hay cerca con precio, fecha/hora y ubicación, **para** descartar sin abrir cada opción | Camila | Must |
| JTBD-2 | **Cuando** tengo un presupuesto ajustado, **quiero** filtrar por precio, fecha y distancia, **para** quedarme solo con lo que puedo pagar y me queda cerca | Camila | Must |
| JTBD-3 | **Cuando** encontré una opción que me convence, **quiero** verificar que sigue vigente, **para** no mandar al grupo algo que ya cambió o no existe | Camila | Must |
| JTBD-4 | **Cuando** ya elegí una opción, **quiero** mandarla al grupo con todos los datos, **para** que nadie tenga que preguntar qué, cuándo, cuánto ni dónde | Camila | Must |
| JTBD-5 | **Cuando** estoy comparando dos opciones parecidas, **quiero** ver cuánta gente marcó interés, **para** tener un criterio más de decisión | Camila | Should |
| JTBD-6 | **Cuando** una opción me gusta, **quiero** contar públicamente que quiero ir y poder retirarlo, **para** dejar señal sin comprometerme a asistir | Camila | Should |
| JTBD-7 | **Cuando** organizo un evento, **quiero** publicarlo en menos tiempo del que tardo en armar un flyer, **para** que sumar este canal no me cueste trabajo extra | Organizador | Should |
| JTBD-8 | **Cuando** cambia la hora o el precio, **quiero** corregirlo en un solo lugar, **para** no tener que avisar canal por canal | Organizador | Should |
| JTBD-9 | **Cuando** publiqué un evento, **quiero** ver cuánta gente marcó interés, **para** dimensionar la convocatoria | Organizador | Should |
| JTBD-10 | **Cuando** veo algo que me gusta pero no es para este finde, **quiero** guardarlo aparte, **para** encontrarlo después sin marcar interés | Camila | Could |

---

## 6. Functional Requirements

> Ordenados por prioridad MoSCoW. La secuencia de implementación está en la sección 10: **primero el bloque Must** (lista + comparación + compartir), y recién después el bloque de interés, que depende de una decisión abierta (OQ-1).

### Must Have — bloqueantes de lanzamiento

- [ ] **FR-01 · Lista de eventos vigentes como pantalla de inicio.** Al abrir la app, lo primero es la lista, no un buscador ni un onboarding. Orden por defecto: fecha ascendente y luego cercanía. Solo eventos cuya fecha/hora de fin no pasó.
- [ ] **FR-02 · Tarjeta autosuficiente.** Cada tarjeta muestra, sin abrir el detalle: nombre, **precio** (o "Gratis"; nunca vacío), fecha y hora, y ubicación o distancia/zona. Un evento sin precio cargado no puede publicarse (ver FR-10).
- [ ] **FR-03 · Indicador de vigencia en la tarjeta.** Estado visible y explícito: vigente / actualizado recientemente / cancelado. Un evento cancelado se muestra marcado como tal, no desaparece en silencio.
- [ ] **FR-04 · Filtros básicos.** Fecha (hoy / este fin de semana), precio (rango o tope) y distancia/zona. Combinables, reversibles en un toque, y con el número de resultados visible. Incluye estado vacío que indica qué filtro relajar.
- [ ] **FR-05 · Detalle del evento.** Descripción breve, ubicación con punto de referencia, estado de vigencia, y acceso al mapa **delegado a la app externa** del dispositivo.
- [ ] **FR-06 · Compartir con mensaje ya armado.** Un toque abre el share sheet nativo con un mensaje que contiene nombre, fecha/hora, precio, lugar y enlace al evento. La persona no escribe ni copia nada. Objetivo asociado: KR5 = 0 datos faltantes.

### Should Have — alto valor, con dependencia abierta

- [ ] **FR-07 · Identificación liviana.** Identificador local del dispositivo, generado al primer uso, sin registro, sin correo y sin datos personales. Su único fin es no contar dos veces a la misma persona. *Bloqueado por OQ-1.*
- [ ] **FR-08 · Acción "Me interesa" en el detalle, revertible.** Un toque marca, otro desmarca, sin costo ni penalización. Vive en el **detalle**, no en la tarjeta: marcar interés supone haber verificado los datos.
- [ ] **FR-09 · Contador público anónimo.** Se muestra en tarjeta y detalle como **un número, nunca una lista de nombres**. Sujeto a un umbral mínimo por definir (ver FR-16 y OQ-3).
- [ ] **FR-10 · Publicar evento (formulario corto).** Campos obligatorios: nombre, fecha/hora de inicio, precio (o "Gratis"), ubicación. Opcionales: descripción breve, imagen. Objetivo: publicación completa en ≤ 120 s (KR7).
- [ ] **FR-11 · "Mis eventos" con interesados por evento.** El organizador ve el número de interesados donde ya administra sus eventos, sin sección nueva. Acompañado de una leyenda fija: **no es una confirmación de asistencia**.
- [ ] **FR-12 · Editar y cancelar.** Un solo lugar para corregir hora, precio o ubicación. Editar marca el evento como "actualizado recientemente" (FR-03); cancelar lo marca como cancelado sin borrarlo.
- [ ] **FR-13 · Redacción honesta de la etiqueta.** La interfaz nunca usa "Voy", "Asistiré" ni equivalentes, y el detalle explica en una línea qué significa marcar interés. Requisito de confianza, no de función. Objetivo asociado: KR6.

### Could Have — se difieren si aprieta el tiempo

- [ ] **FR-14 · Sello "actualizado hace X"** en el detalle, además del estado binario de FR-03.
- [ ] **FR-15 · Guardar para más tarde**, separado de "Me interesa" (guardar ≠ interesar: son intenciones distintas).
- [ ] **FR-16 · Umbral del contador**: por debajo de N interesados no se muestra número. Depende de OQ-3.
- [ ] **FR-17 · Aviso a quienes marcaron interés** cuando el evento se cancela o cambia, **dentro de la app** (sin notificaciones push).

### Won't Have — explícitamente fuera de esta versión

| # | Excluido | Por qué |
|---|---|---|
| FR-W01 | Compra o venta de entradas | Cambia el modelo del producto y agrega pagos; el problema es decidir, no pagar |
| FR-W02 | Chat dentro de la app | La decisión ocurre en WhatsApp a propósito; competir con eso es una apuesta distinta |
| FR-W03 | Perfiles públicos, seguidores y lista de nombres de interesados | Crea identidad pública y presión social; el contador da la señal sin ese costo |
| FR-W04 | Confirmación de asistencia real ("Voy" verificado) | La app no puede verificar quién asistió; prometerlo destruye la confianza en el dato |
| FR-W05 | Recomendaciones personalizadas | Requiere historial de uso que el MVP no tiene y no ataca la causa raíz |
| FR-W06 | Analítica avanzada y publicidad para organizadores | La evidencia dice que el organizador prioriza velocidad, no métricas |
| FR-W07 | Integración automática con redes sociales | Dependencia externa incierta; se evaluará después de validar el flujo base |
| FR-W08 | Navegación o transporte propios | El mapa se delega a la app externa del dispositivo |
| FR-W09 | Notificaciones push | Requiere permisos y una política de frecuencia que no está diseñada |
| FR-W10 | Cuentas de usuario con contraseña | Contradice FR-07; el registro es fricción en una tarea de consumo |

**Distribución:** 6 Must / 7 Should / 4 Could = 17 requisitos priorizados → Must = **35 %**.

---

## 7. Non-Functional Requirements

| Categoría | Requisito | Umbral |
|---|---|---|
| Rendimiento | Lista inicial utilizable | ≤ 3 s en conexión móvil lenta (3G simulada) |
| Rendimiento | Respuesta al aplicar/quitar un filtro | ≤ 300 ms percibidos |
| Comparación | Lectura de qué/cuándo/cuánto/dónde en una tarjeta | ≤ 10 s por opción (medido en la prueba) |
| Densidad | Tarjetas completas visibles sin scroll | ≥ 3 en pantalla de 6,1" |
| Uso a una mano | Acciones primarias (filtros, compartir, "Me interesa") | En el tercio inferior; área táctil ≥ 44 × 44 pt |
| Red inestable | Contenido ya cargado | Recorrible sin conexión; "Me interesa" se encola y muestra estado "pendiente de sincronizar" |
| Accesibilidad | WCAG 2.1 AA | Contraste ≥ 4,5:1 en texto normal y ≥ 3:1 en texto grande |
| Accesibilidad | El precio y la vigencia nunca se comunican solo por color | Siempre acompañados de texto o ícono con etiqueta |
| Accesibilidad | Escalado de fuente del sistema | Legible y sin recortes hasta 200 % |
| Privacidad | Datos personales recolectados | Ninguno. Identificador local de dispositivo, no reversible a una persona |
| Privacidad | Exposición del interés | Solo agregado numérico; nunca nombres, ni al organizador |
| Seguridad | Edición de un evento | Solo desde el dispositivo/enlace del organizador que lo creó (mecanismo por definir — OQ-4) |
| Plataforma | Móvil primero | Pantallas desde 360 px de ancho; vertical |
| Escalabilidad | No aplica en esta versión | MVP con datos de prueba; el volumen real es un problema posterior |
| Idioma | Español local, sin jerga técnica | Etiquetas de una o dos palabras |

---

## 8. Out of Scope

Además de los `FR-W*` de la sección 6, quedan fuera del alcance de este PRD:

- **La segunda ronda de investigación con usuarios reales.** Es prerrequisito para validar el PRD, pero es un entregable propio, no parte del MVP.
- **El sistema de diseño y el prototipo visual.** Este documento define el *qué*; los wireframes y el prototipo son el *cómo* y vienen después (sección 10).
- **La arquitectura de datos y el backend real.** El MVP corre con datos de prueba (ver sección 9).
- **Moderación de contenido y verificación de organizadores.** Necesarios en producción, irrelevantes en un MVP evaluado en laboratorio.
- **Estrategia de captación de organizadores** (cómo se llenan los eventos reales en un lanzamiento).
- **Monetización.**
- **Localización o soporte multiidioma.**
- **Mitigación del sesgo de popularidad.** El riesgo está identificado y aceptado en esta versión (ver sección 12, OQ-6); resolverlo no entra al MVP.

---

## 9. Technical Constraints & Dependencies

### Restricciones

- **Móvil primero, sesiones cortas, posible uso con una sola mano.** Es contexto de uso, no preferencia estética.
- **Conectividad móvil inestable.** Ninguna acción crítica puede depender de una respuesta inmediata del servidor.
- **Sin cuentas ni registro** (FR-07 / FR-W10). Esto restringe qué se puede persistir y verificar.
- **Datos de prueba.** El MVP se implementa con un conjunto de eventos semilla; no hay carga real de organizadores.
- **Compartir usa el share sheet nativo del sistema**, no una integración propia con WhatsApp.
- **El mapa se delega a la aplicación externa** del dispositivo (FR-05).
- **Proyecto académico:** dos personas, tiempo acotado por el calendario del curso, y la evaluación con usuarios es parte del entregable.

### Dependencias

| Dependencia | Tipo | Responsable | Estado | Cuándo |
|---|---|---|---|---|
| Decisión de identificación mínima para el contador (OQ-1) | **Bloqueante** de FR-07, FR-08, FR-09, FR-11 | Equipo | Abierta | Antes de iniciar el bloque Should |
| Conjunto de datos de prueba realista (≥ 20 eventos, precios y zonas variados) | Bloqueante de la evaluación | Equipo | No iniciado | Antes de la prueba con usuarios |
| Participantes reales para la evaluación (≥ 5 buscadores + ≥ 2 organizadores) | Bloqueante de todos los KR | Equipo | No iniciado | Antes de la evaluación |
| Share sheet nativo del sistema operativo | No bloqueante | Plataforma | Disponible | — |
| App de mapas del dispositivo | No bloqueante | Plataforma | Disponible | — |
| Definición del mecanismo de edición del organizador (OQ-4) | Bloqueante de FR-12 | Equipo | Abierta | Antes de FR-10/FR-12 |

---

## 10. Timeline & Milestones

Las fechas absolutas dependen del calendario del curso y están **por confirmar**. Lo que sí está fijo es el **orden**, porque encierra la dependencia de la sección 9.

| # | Hito | Descripción | Estado | Responsable |
|---|---|---|---|---|
| M0 | Investigación inicial | Brief, evidencias simuladas, persona, app map, flujo | **Hecho** (19/08/2026) | Equipo |
| M1 | PRD aprobado | Este documento revisado y acordado | En curso | Equipo |
| M2 | Wireframes del bloque Must | Lista, tarjeta, filtros, detalle, compartir | Pendiente | Equipo |
| M3 | Prototipo navegable del bloque Must | Con datos de prueba; recorre el flujo completo de `flujo-v0.1.md` | Pendiente | Equipo |
| M4 | **Decisión OQ-1** (identificación mínima) | Desbloquea el bloque Should | Pendiente | Equipo |
| M5 | Bloque Should | "Me interesa" + contador + publicar/editar + Mis eventos | Pendiente | Equipo |
| M6 | Evaluación con usuarios reales | Prueba moderada; se miden KR1–KR7 | Pendiente | Equipo |
| M7 | Ajustes y cierre | Correcciones según hallazgos + PRD v0.2 | Pendiente | Equipo |

**Regla de secuencia:** M3 puede evaluarse por sí solo. Si el tiempo aprieta, **se recorta el bloque Should, no la evaluación con usuarios**: un MVP sin prueba de usabilidad no responde ninguna de las preguntas abiertas.

---

## 11. Stakeholders

| Quién | Rol | Involucramiento |
|---|---|---|
| Ruben Orestes Justiniano Becerra (216163501) | Integrante del equipo | Decisor — aprueba alcance, diseño y entrega |
| Faryd Lucas Soliz Marquez (221045880) | Integrante del equipo | Decisor — aprueba alcance, diseño y entrega |
| Docente de la materia IHC | Evaluador | Decisor sobre criterios académicos; informado sobre el avance |
| Participantes de la evaluación (perfil buscador) | Fuente de validación | Contribuyen — sus hallazgos pueden cambiar requisitos Must |
| Organizadores pequeños participantes | Fuente de validación | Contribuyen — validan FR-10 a FR-12 |

---

## 12. Open Questions

| # | Pregunta | Bloquea | Responsable | Cuándo se resuelve | Estado |
|---|---|---|---|---|---|
| OQ-1 | ¿Qué identificación mínima necesita "Me interesa" para que el contador no cuente dos veces a la misma persona? ¿Alcanza el dispositivo o hace falta cuenta? | FR-07, FR-08, FR-09, FR-11 | Equipo | M4 | Abierta |
| OQ-2 | ¿La comparación se resuelve realmente en la lista, o el usuario abre igual varios detalles? | KR4, diseño de FR-02 | Equipo | M6 | Abierta |
| OQ-3 | ¿Desde qué número el contador aporta y desde cuál desinforma? Un evento con 2 interesados, ¿muestra "2" o no muestra nada? | FR-09, FR-16 | Equipo | M6 | Abierta |
| OQ-4 | ¿"Mis eventos" necesita cuenta o alcanza con un enlace de edición? | FR-12, seguridad | Equipo | M5 | Abierta |
| OQ-5 | ¿"Me interesa" es la etiqueta correcta, o el usuario espera "Voy" y le atribuye un compromiso que la app no sostiene? | FR-13, KR6 | Equipo | M6 | Abierta |
| OQ-6 | ¿Cómo se evita que el sesgo de popularidad entierre a los organizadores pequeños? | Riesgo R-1 | Equipo | Posterior al MVP | Abierta — riesgo aceptado |
| OQ-7 | ¿Los usuarios prefieren compartir una tarjeta, un enlace o un mensaje ya redactado? | FR-06 | Equipo | M6 | Abierta |
| OQ-8 | ¿La tarjeta necesita imagen o alcanza con texto? Afecta cuántos eventos se comparan de un vistazo. | FR-02, densidad | Equipo | M2 | Abierta |
| OQ-9 | ¿Distancia exacta o referencia de zona? | FR-02, FR-04 | Equipo | M6 | Abierta |
| OQ-10 | ¿Cómo se comunica la vigencia sin que el usuario tenga que interpretarla? | FR-03, FR-14 | Equipo | M2 | Abierta |
| OQ-11 | ¿El paso "Me interesa" ocurre antes o después de compartir? El flujo v0.1 lo puso antes, sin comprobarlo. | FR-08, orden del flujo | Equipo | M6 | Abierta |
| OQ-12 | ¿Qué pasa con el interés cuando el evento se cancela? ¿Se avisa a quienes marcaron? | FR-17 | Equipo | M5 | Abierta |
| OQ-13 | ¿Qué información mínima acepta cargar un organizador sin sentir que hace más trabajo que en Instagram? | FR-10, KR7 | Equipo | M6 | Abierta |
| OQ-14 | ¿La app reduce realmente el número de pasos y aplicaciones frente al método actual? | KR2, KR3 — hipótesis central | Equipo | M6 | **Abierta — es la pregunta que valida o refuta el proyecto** |

---

## 13. Riesgos

| # | Riesgo | Impacto | Mitigación en el MVP |
|---|---|---|---|
| R-1 | **Sesgo de popularidad:** el contador en la tarjeta hace que los eventos grandes acumulen interés y entierren a los pequeños, que son el usuario secundario | Alto — daña a la persona secundaria | Ninguna en esta versión. **Riesgo asumido**; se observa en M6 (OQ-6) |
| R-2 | El contador es **decorativo**: no cambia lo que la persona elige, solo confirma lo ya decidido | Medio — peso muerto en la tarjeta | Se mide en M6; si es decorativo, sale de la tarjeta |
| R-3 | "Me interesa" se lee como **"Voy"** y el organizador dimensiona mal la convocatoria | Alto — rompe la confianza en el dato | FR-13 + leyenda fija en FR-11; se verifica con KR6 |
| R-4 | **Sin organizadores no hay eventos**, y sin eventos la lista no sirve | Alto fuera del laboratorio | El MVP usa datos de prueba; la captación queda fuera de alcance (sección 8) |
| R-5 | Toda la evidencia es **simulada con IA** y puede estar sesgada hacia lo que el equipo ya creía | Alto — puede invalidar el problema | M6 con usuarios reales es obligatorio, no opcional |
| R-6 | Sin cuentas, el identificador de dispositivo permite **inflar el contador** cambiando de dispositivo o reinstalando | Medio | Aceptado en el MVP; se documenta el límite del dato (OQ-1) |

---

## Apéndice

### A. Trazabilidad: requisito → evidencia

| Requisito | Respaldo | Fuente |
|---|---|---|
| FR-02 (precio en la tarjeta) | "Si no encuentro rápido el precio, lo dejo de lado"; "si una opción no tiene precio, queda fuera de la comparación" | Instancias 1 y 3 |
| FR-02 (ubicación/distancia en la tarjeta) | "La ubicación influye bastante porque nadie quiere cruzar toda la ciudad" | Instancia 2 |
| FR-03 (vigencia) | Flyer con fecha vieja; cambio comunicado en otra historia | Instancias 1 y 2 |
| FR-04 (filtros) | "Primero vemos qué opciones son accesibles y después decidimos cuál nos gusta más" | Instancia 3 |
| FR-06 (compartir armado) | "Terminamos con varias capturas y links" | Instancias 1 y 2 |
| FR-10 (formulario corto) | "Que sea rápido. No quisiera llenar un formulario largo" | Instancia 4 |
| FR-12 (editar en un lugar) | "Tengo que repetir la información cuando cambia algo" | Instancia 4 |
| Urgencia de la ventana de decisión (NFR de rendimiento) | "Cuando estoy decidiendo para esa misma noche no quiero esperar una respuesta" | Instancia 2 |
| **FR-08, FR-09, FR-11 ("Me interesa" y contador)** | **Sin respaldo.** Es una decisión de diseño del equipo, no un hallazgo de la investigación | — |

### B. Alternativas consideradas

| Opción | A favor | En contra | Por qué no |
|---|---|---|---|
| Buscador como pantalla principal | Patrón conocido; escala a muchos eventos | Obliga a saber qué buscar | La evidencia dice que el problema es **comparar**, no encontrar. La comparación tiene que ocurrir en la lista |
| Precio solo en el detalle | Tarjeta más limpia, más eventos por pantalla | Obliga a abrir cada opción | Rompe la comparación: el precio es dato de descarte |
| "Me interesa" en la tarjeta | Menos toques, más señal | Abarata la señal: se marca sin verificar los datos | El interés debe suponer verificación; en la tarjeta se vuelve ruido |
| Lista de nombres de interesados | Señal social más fuerte y verificable | Crea identidad pública, presión y un producto social | Fuera del alcance decidido en el brief (FR-W03) |
| Etiqueta "Voy" | Más natural, comunica intención con fuerza | La app no verifica asistencia | Promete algo que no sostiene; destruye la confianza en el dato (R-3) |
| Cuentas con registro | Contador confiable, edición segura | Fricción alta en una tarea de consumo | Contradice el contexto de uso; se prefiere identificación liviana (FR-07) |
| Chat propio para decidir en la app | Cierra el ciclo dentro del producto | Compite con WhatsApp, donde el grupo ya está | El flujo termina afuera a propósito (FR-W02) |

### C. Referencias

- `ihc-proy-1/brief/brief-v0.2.0.md` — problema, hipótesis, alcance inicial, criterios de éxito
- `ihc-proy-1/research/evidencias.md` — 4 entrevistas simuladas con IA y síntesis
- `ihc-proy-1/persona/persona-v0.1.md` — Camila
- `ihc-proy-1/app-map/app-map-v0.1.md` — secciones, contenidos y justificación
- `ihc-proy-1/app-map/flujo-v0.1.md` — flujo principal de una sola tarea

### D. Historial de versiones

| Versión | Fecha | Autores | Cambios |
|---|---|---|---|
| v0.1 | 19/08/2026 | Equipo | Primer PRD del MVP, derivado del brief v0.2.0, la persona v0.1, el app map v0.1, el flujo v0.1 y las evidencias simuladas |
