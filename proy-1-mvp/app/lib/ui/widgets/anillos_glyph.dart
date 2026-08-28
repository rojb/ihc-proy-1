import 'package:flutter/material.dart';

import '../theme.dart';

/// Los anillos de Santa Cruz, dibujados.
///
/// La ciudad se ordena en anillos concéntricos y la gente ubica todo así
/// ("por el segundo anillo"). Se usa como marca del dato de ubicación en vez
/// de un pin genérico de mapa: dice de qué ciudad habla la app, y el punto
/// lleno marca el lugar dentro del anillo.
///
/// Es decorativo: la información va siempre en el texto que lo acompaña, nunca
/// solo en el dibujo.
class AnillosGlyph extends StatelessWidget {
  const AnillosGlyph({super.key, this.size = 14, this.color = AppColors.green});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _AnillosPainter(color)),
      ),
    );
  }
}

class _AnillosPainter extends CustomPainter {
  const _AnillosPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Paint stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..color = color;

    canvas.drawCircle(center, size.width * 0.46, stroke);
    canvas.drawCircle(center, size.width * 0.28, stroke);

    canvas.drawCircle(
      center,
      size.width * 0.11,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_AnillosPainter oldDelegate) => oldDelegate.color != color;
}
