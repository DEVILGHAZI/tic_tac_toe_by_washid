
import 'package:flutter/material.dart';

class GridPatternPainter extends CustomPainter {
  final double offset;
  final Color color;

  GridPatternPainter({required this.offset, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    final adjustedOffset = offset % spacing;

    for (double i = adjustedOffset; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    for (double i = adjustedOffset; i < size.height; i += spacing) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(GridPatternPainter oldDelegate) {
    return oldDelegate.offset != offset || oldDelegate.color != color;
  }
}