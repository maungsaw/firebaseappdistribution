import 'package:flutter/material.dart';

class SignaturePainter extends CustomPainter {
  final List<Offset?> points;
  final Color penColor;
  final double strokeWidth;

  SignaturePainter({
    required this.points,
    this.penColor = Colors.black,
    this.strokeWidth = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = penColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    for (int i = 0; i < points.length - 1; i++) {
      // If both current point and next point are valid, draw a line segment
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
      // If a point is isolated (tap), draw a small circle/dot
      else if (points[i] != null && points[i + 1] == null) {
        canvas.drawCircle(points[i]!, strokeWidth / 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant SignaturePainter oldDelegate) {
    // Repaint whenever the list of points changes
    return true;
  }
}
