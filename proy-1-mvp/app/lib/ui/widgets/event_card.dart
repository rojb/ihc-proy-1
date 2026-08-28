import 'package:flutter/material.dart';

import '../../api/event.dart';
import '../format.dart';
import '../spacing.dart';
import '../theme.dart';
import 'anillos_glyph.dart';
import 'validity_badge.dart';

/// FR-02 · Tarjeta autosuficiente: nombre, precio, fecha/hora y ubicación, sin
/// abrir el detalle.
///
/// El precio es lo más pesado de la tarjeta después del nombre, y va primero en
/// la fila de datos. Sale directo de la evidencia: es el dato con el que la
/// gente descarta ("si no encuentro rápido el precio, lo dejo de lado"). Por la
/// misma razón la tarjeta no lleva imagen: sin foto entran cuatro tarjetas
/// completas en pantalla y la comparación ocurre en la lista, que es lo que
/// FR-01 y KR4 persiguen. OQ-8 sigue abierta y esto es lo que hay que probar.
class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    this.interestPending = false,
  });

  final Event event;
  final VoidCallback onTap;

  /// NFR de red inestable · la marca todavía no llegó al servidor.
  final bool interestPending;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final bool cancelled = event.validity == Validity.cancelado;

    return Semantics(
      button: true,
      label: _semanticSummary(),
      excludeSemantics: true,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.s2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusM),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        formatDayTime(event.startsAt).toUpperCase(),
                        style: text.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s1),
                    ValidityBadge(validity: event.validity),
                  ],
                ),
                const SizedBox(height: AppSpacing.half),
                Text(
                  event.name,
                  style: text.titleMedium?.copyWith(
                    decoration: cancelled ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.s2),
                // Precio y lugar comparten fila: son los dos datos de descarte.
                // Wrap y no Row para que a 200 % de escala se acomoden en dos
                // líneas en vez de recortarse.
                Wrap(
                  spacing: AppSpacing.s2,
                  runSpacing: AppSpacing.half,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Text(
                      formatPrice(event),
                      style: text.headlineSmall?.copyWith(
                        color: event.isFree ? AppColors.green : AppColors.ink,
                      ),
                    ),
                    _PlaceLabel(event: event),
                  ],
                ),
                const SizedBox(height: AppSpacing.s1),
                _InterestLine(
                  count: event.interestCount,
                  pending: interestPending,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Lo que lee un lector de pantalla: los cuatro datos en un solo enunciado.
  String _semanticSummary() {
    final StringBuffer buffer = StringBuffer()
      ..write(event.name)
      ..write('. ${formatFullDayTime(event.startsAt)}')
      ..write('. ${formatPrice(event)}')
      ..write('. ${event.locationName}, ${event.zone}');

    if (event.distanceKm != null) {
      buffer.write(', a ${formatDistance(event.distanceKm)}');
    }

    buffer.write('. ${_validityWord()}');
    buffer.write('. ${event.interestCount} personas marcaron interés.');

    return buffer.toString();
  }

  String _validityWord() => switch (event.validity) {
        Validity.cancelado => 'Cancelado',
        Validity.actualizadoReciente => 'Actualizado recientemente',
        Validity.vigente => 'Vigente',
      };
}

class _PlaceLabel extends StatelessWidget {
  const _PlaceLabel({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final String distance = formatDistance(event.distanceKm);
    final String label =
        distance.isEmpty ? event.zone : '${event.zone} · $distance';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const AnillosGlyph(),
        const SizedBox(width: AppSpacing.s1),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

/// FR-09 · El interés se muestra como un número, nunca como una lista de
/// nombres. En la tarjeta es un criterio más de comparación (JTBD-5); no es
/// una acción, por eso acá no se puede tocar.
class _InterestLine extends StatelessWidget {
  const _InterestLine({required this.count, required this.pending});

  final int count;
  final bool pending;

  @override
  Widget build(BuildContext context) {
    final TextStyle? style = Theme.of(context).textTheme.bodySmall;

    return Row(
      children: <Widget>[
        Icon(Icons.people_outline, size: 16, color: AppColors.inkSoft),
        const SizedBox(width: AppSpacing.s1),
        Text('$count interesados', style: style),
        if (pending) ...<Widget>[
          const SizedBox(width: AppSpacing.s2),
          Icon(Icons.cloud_off, size: 14, color: AppColors.amber),
          const SizedBox(width: AppSpacing.s1),
          Text(
            'pendiente de sincronizar',
            style: style?.copyWith(color: AppColors.amber),
          ),
        ],
      ],
    );
  }
}
