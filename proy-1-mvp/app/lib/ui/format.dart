import 'package:intl/intl.dart';

import '../api/event.dart';

/// Formatos de lectura. Están juntos porque el PRD mide cuánto tarda alguien en
/// leer qué / cuándo / cuánto / dónde en una tarjeta (≤ 10 s): la forma en que
/// se escribe cada dato es parte del requisito, no una preferencia.

/// FR-02 · El precio nunca aparece vacío. Cero es "Gratis", escrito con todas
/// las letras: un "Bs 0" obliga a interpretar.
String formatPrice(Event event) {
  if (event.isFree) {
    return 'Gratis';
  }

  final double amount = event.priceCents / 100;
  final String formatted = amount == amount.roundToDouble()
      ? amount.round().toString()
      : amount.toStringAsFixed(2);

  return 'Bs $formatted';
}

/// "Vie 21 · 23:00". Día de la semana primero porque la persona piensa en
/// "el viernes", no en "el 21".
String formatDayTime(DateTime when) {
  final String day = DateFormat('EEE d', 'es').format(when);
  final String time = DateFormat('HH:mm', 'es').format(when);
  return '${_capitalize(day)} · $time';
}

/// Versión larga para el detalle: "Viernes 21 de agosto, 23:00".
String formatFullDayTime(DateTime when) {
  final String day = DateFormat("EEEE d 'de' MMMM", 'es').format(when);
  final String time = DateFormat('HH:mm', 'es').format(when);
  return '${_capitalize(day)}, $time';
}

/// FR-02 · Distancia solo cuando se puede calcular; si no, manda la zona.
String formatDistance(double? distanceKm) {
  if (distanceKm == null) {
    return '';
  }
  if (distanceKm < 1) {
    return '${(distanceKm * 1000).round()} m';
  }
  return '${distanceKm.toStringAsFixed(1).replaceAll('.', ',')} km';
}

/// FR-14 · "Actualizado hace X". Se queda en trazo grueso a propósito: la
/// precisión no aporta, lo que importa es si el cambio es reciente.
String formatTimeAgo(DateTime moment) {
  final Duration elapsed = DateTime.now().difference(moment);

  if (elapsed.inMinutes < 60) {
    return 'hace ${elapsed.inMinutes} min';
  }
  if (elapsed.inHours < 24) {
    return 'hace ${elapsed.inHours} h';
  }
  return 'hace ${elapsed.inDays} d';
}

String _capitalize(String value) {
  if (value.isEmpty) {
    return value;
  }
  return value[0].toUpperCase() + value.substring(1);
}
