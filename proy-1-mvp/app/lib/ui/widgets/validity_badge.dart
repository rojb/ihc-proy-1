import 'package:flutter/material.dart';

import '../../api/event.dart';
import '../spacing.dart';
import '../theme.dart';

/// FR-03 · Indicador de vigencia.
///
/// Siempre lleva ícono y texto. El NFR de accesibilidad prohíbe comunicar la
/// vigencia solo por color, y además el color no sobrevive a una captura de
/// pantalla reenviada por WhatsApp, que es exactamente lo que pasa con estos
/// eventos.
///
/// OQ-10 sigue abierta: falta comprobar si estas tres etiquetas se entienden
/// sin que nadie las explique.
class ValidityBadge extends StatelessWidget {
  const ValidityBadge({super.key, required this.validity});

  final Validity validity;

  @override
  Widget build(BuildContext context) {
    final ({String label, IconData icon, Color foreground, Color background})
        style = switch (validity) {
      Validity.cancelado => (
          label: 'Cancelado',
          icon: Icons.block,
          foreground: AppColors.urucu,
          background: AppColors.urucuSoft,
        ),
      Validity.actualizadoReciente => (
          label: 'Actualizado',
          icon: Icons.published_with_changes,
          foreground: AppColors.amber,
          background: AppColors.amberSoft,
        ),
      Validity.vigente => (
          label: 'Vigente',
          icon: Icons.check_circle_outline,
          foreground: AppColors.green,
          background: AppColors.greenSoft,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s1,
        vertical: AppSpacing.half,
      ),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(style.icon, size: 16, color: style.foreground),
          const SizedBox(width: AppSpacing.s1),
          Text(
            style.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: style.foreground,
            ),
          ),
        ],
      ),
    );
  }
}
