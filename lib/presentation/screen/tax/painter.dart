import 'dart:ui';

import 'package:flutter/material.dart';

class DashedStepperPainter extends CustomPainter {
  final int currentStep;
  final int totalSteps;
  final double itemHeight;

  DashedStepperPainter({
    required this.currentStep,
    required this.totalSteps,
    required this.itemHeight,
  });

  @override
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final Paint nodePaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < totalSteps; i++) {
      double y = (i * itemHeight) + (itemHeight / 2);

      // 1. Draw Dashed Connection Lines
      if (i < totalSteps - 1) {
        double nextY = ((i + 1) * itemHeight) + (itemHeight / 2);

        // Lines: Completed (Blue with 0.5 opacity) vs Future (Grey)
        linePaint.color = i < currentStep
            ? Colors.blue.withValues(alpha: .5)
            : Colors.grey[300]!;

        final Path path = Path()
          ..moveTo(size.width / 2, y + 10)
          ..lineTo(size.width / 2, nextY - 10);

        const double dashWidth = 4, dashSpace = 4;
        for (PathMetric measurePath in path.computeMetrics()) {
          double distance = 0.0;
          while (distance < measurePath.length) {
            canvas.drawPath(
              measurePath.extractPath(distance, distance + dashWidth),
              linePaint,
            );
            distance += dashWidth + dashSpace;
          }
        }
      }

      // 2. Draw Nodes with refined colors
      if (i < currentStep) {
        // Completed: Primary color (Blue) with 0.5 opacity
        nodePaint.color = Colors.blue.withValues(alpha: .5);
        canvas.drawCircle(Offset(size.width / 2, y), 8, nodePaint);
      } else if (i == currentStep) {
        // Active: Primary color (Blue)
        nodePaint.color = Colors.blue;
        nodePaint.style = PaintingStyle.stroke;
        nodePaint.strokeWidth = 2.0;
        canvas.drawCircle(Offset(size.width / 2, y), 10, nodePaint); // Outer
        nodePaint.style = PaintingStyle.fill;
        canvas.drawCircle(Offset(size.width / 2, y), 5, nodePaint); // Inner
      } else {
        // Inactive: Grey color
        nodePaint.color = Colors.grey[300]!;
        nodePaint.style = PaintingStyle.fill;
        canvas.drawCircle(Offset(size.width / 2, y), 8, nodePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedStepperPainter oldDelegate) =>
      oldDelegate.currentStep != currentStep;
}
