import 'package:flutter/material.dart';

class TimelineGridPainter extends CustomPainter {
  final int lineCount;
  final double rowHeight;
  final Color lineColor;

  TimelineGridPainter({
    required this.lineCount,
    required this.rowHeight,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.0;
    for (int i = 0; i < lineCount; i++) {
      canvas.drawLine(
        Offset(0, i * rowHeight),
        Offset(size.width, i * rowHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant TimelineGridPainter oldDelegate) => false;
}
