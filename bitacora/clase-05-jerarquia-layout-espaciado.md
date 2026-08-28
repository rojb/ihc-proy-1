# Clase 5 — Jerarquía, layout y espaciado

**Proyecto:** App de eventos en Santa Cruz de la Sierra
**Fecha:** 27/08/2026
**Pantalla auditada:** Lista de eventos (inicio) y Detalle del evento
**Código:** `proy-1-mvp/app/` (Flutter)
**Wireframes:** `wireframes/`

---

## La auditoría, paso a paso

### 1. Nombrar el momento

> **La persona está comparando** opciones para el fin de semana, todavía sin plan, y necesita descartar rápido.

En el detalle el momento es otro: **está verificando** una opción antes de mandarla al grupo.

### 2. Ordenar prioridades

| Nivel | Lista de eventos | Detalle del evento |
|---|---|---|
| 1 · Orientar | Día y hora del evento | Nombre del evento y su vigencia |
| 2 · Informar | **Precio**, después lugar y distancia | Precio, cuándo, dónde |
| 3 · Actuar | Tocar la tarjeta | Compartir al grupo |

### 3. Detectar grupos

- **Tarjeta:** día/hora + vigencia se leen juntos · nombre solo · precio + lugar juntos (los dos datos de descarte) · interesados aparte, es apoyo.
- **Detalle:** los cuatro datos son un bloque · el aviso de interés es otro · las dos acciones son otro.

### 4. La mejora elegida

> **Unificar el espaciado en una escala de base 8 y aplicarla a la lista y al detalle.**

---

## Antes

La jerarquía de la aplicación ya estaba resuelta y documentada: el precio es lo más pesado de la tarjeta, la tarjeta no lleva imagen, el interés es un número y nunca una lista de nombres. Eso no era el problema.

**El problema era el espaciado.** Cada pantalla elegía sus distancias por separado. Medidas encontradas en el código antes del cambio:

| Archivo | Distancias sueltas |
|---|---|
| `widgets/event_card.dart` | 14, 12, 10, 8, 6, 4 · radio 14 · ícono 15 |
| `widgets/validity_badge.dart` | 8, 4 · ícono 14 |
| `events_list_page.dart` | 16, 12, 10, 8, 32, 20 · ancho de botón 140 |
| `event_detail_page.dart` | 20, 14, 12, 10, 8, 4, 2 · radio 14 |

Diez valores distintos de espaciado conviviendo. Ninguno estaba *mal* por separado: el problema es que **la distancia no significaba nada**. Dos elementos a 10 px y otros dos a 12 px se leen igual de relacionados, así que el espacio dejaba de comunicar qué pertenece a qué.

Además el margen lateral no era el mismo en las dos pantallas: la lista usaba 16 y el detalle 20, así que el contenido se corría al navegar entre una y otra.

---

## Cambio

**En el código** — `proy-1-mvp/app/lib/ui/spacing.dart`, archivo nuevo:

```dart
abstract final class AppSpacing {
  static const double half = 4;   // se lee como una sola unidad
  static const double s1 = 8;     // dentro de un grupo
  static const double s2 = 16;    // contenido relacionado, margen lateral
  static const double s3 = 24;    // entre grupos
  static const double s4 = 32;    // entre secciones

  static const double radiusS = 8;
  static const double radiusM = 16;
  static const double radiusPill = 999;
}
```

Aplicado en cinco archivos: `theme.dart`, `events_list_page.dart`, `event_detail_page.dart`, `widgets/event_card.dart`, `widgets/validity_badge.dart`. **No queda ninguna distancia escrita a mano en esos archivos.**

Cambios con efecto visible:

| Qué | Antes | Ahora | Por qué |
|---|---|---|---|
| Margen lateral del detalle | 20 | 16 | Igual que la lista: el contenido deja de correrse al navegar |
| Separación entre tarjetas | 10 | 16 | Cada tarjeta es una opción distinta, no parte de un bloque |
| Nombre → precio en la tarjeta | 10 | 16 | Separa el "qué es" del "cuánto sale" |
| Etiqueta → valor en el detalle | 2 | 4 | Se leen como una sola unidad, sin quedar pegados |
| Ícono → texto, en toda la app | 4, 6 y 12 | 8 | Una sola regla, explicable en una frase |
| Radio de tarjetas | 14 | 16 | El redondeo también entra en la escala |

**En Figma** — los siete wireframes de `wireframes/svg/` usan la misma escala. Se corrigieron los campos de formulario (44 → 48) y los indicadores de vigencia (84 × 20 → 88 × 24), que eran las dos medidas fuera de escala que quedaban.

**Verificación:** `flutter analyze` → *No issues found!*

---

## Después

> **PENDIENTE.** Hay que probar la tarea con una persona antes de llenar esta sección.

Cómo hacerlo:

1. Abrir la app en la lista de eventos. **No explicar nada.**
2. Dar una tarea, no una instrucción: *"Necesitás salir el viernes con menos de Bs 40. Mandale una opción a tu grupo."*
3. Observar y **anotar lo que hace**, no lo que opina. Las preguntas van después, nunca durante.

Qué registrar:

- [ ] ¿Sabe dónde empieza?
- [ ] ¿Reconoce el precio sin abrir el evento?
- [ ] ¿Distingue la acción principal en el detalle?
- [ ] ¿Entiende qué pasó después de tocar "Compartir"?
- [ ] ¿Busca algo en un lugar donde no está?
- [ ] ¿Lee "Me interesa" como un compromiso de asistir?

Formato de la observación: *"Buscó la fecha debajo de la lista de cuidados."* — un hecho, no una interpretación.

---

## Siguiente

> **PENDIENTE hasta tener la prueba.**

Lo que ya está identificado para mirar:

- **Riesgo de la escala:** separar las tarjetas a 16 en vez de 10 hace que entre **menos** contenido en pantalla. El equipo sostiene en `OQ-8` que entran cuatro tarjetas completas. Hay que confirmar que sigue siendo cierto en un teléfono real, porque es lo que sostiene que la comparación ocurra en la lista.
- **`OQ-3` sigue abierta:** el contador se muestra siempre, sin umbral. Falta ver si un evento con 2 interesados aporta o desinforma.
- **`OQ-10` sigue abierta:** falta comprobar si "Vigente", "Actualizado" y "Cancelado" se entienden sin que nadie las explique.

---

## Historial de versiones

| Versión | Fecha | Cambios |
|---|---|---|
| v0.1 | 27/08/2026 | Auditoría de lista y detalle, escala de espaciado base 8 aplicada en Figma y en código |
