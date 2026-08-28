import 'api/api_config.dart';
import 'api/event.dart';
import 'ui/format.dart';

/// FR-06 · El mensaje que se comparte al grupo.
///
/// Contiene los cuatro datos con los que la gente decide más el enlace, para
/// que nadie tenga que repreguntar (KR5 = 0 datos faltantes). Las etiquetas van
/// escritas ("Cuándo", "Precio", "Dónde") y no con emojis: el checklist de la
/// evaluación se verifica leyendo el mensaje, y un ícono obliga a interpretar.
///
/// Si el evento está cancelado el mensaje lo dice en la primera línea. Compartir
/// un evento cancelado es una decisión válida —avisarle al grupo— pero no puede
/// pasar desapercibido.
String buildShareMessage(Event event) {
  final StringBuffer buffer = StringBuffer();

  if (event.validity == Validity.cancelado) {
    buffer.writeln('CANCELADO');
  }

  buffer.writeln(event.name);
  buffer.writeln();
  buffer.writeln('Cuándo: ${formatFullDayTime(event.startsAt)}');
  buffer.writeln('Precio: ${formatPrice(event)}');

  final String place = '${event.locationName}, ${event.zone}';
  buffer.writeln('Dónde: $place');
  if (event.reference != null && event.reference!.isNotEmpty) {
    buffer.writeln('Referencia: ${event.reference}');
  }

  buffer.writeln();
  buffer.write('$kEventLinkBase/${event.id}');

  return buffer.toString();
}
