import 'package:flutter/material.dart';

import 'model.dart';
import 'service.dart';

class CustomSignaturePad extends StatefulWidget {
  final CustomSignatureController controller;
  final Color canvasColor;
  final Color penColor;
  final double strokeWidth;
  final Size padSize;

  const CustomSignaturePad({
    super.key,
    required this.controller,
    this.canvasColor = const Color(0xFFF5F5F5),
    this.penColor = Colors.black,
    this.strokeWidth = 3.0,
    this.padSize = Size.infinite,
  });

  @override
  State<CustomSignaturePad> createState() => _CustomSignaturePadState();
}

class _CustomSignaturePadState extends State<CustomSignaturePad> {
  @override
  void initState() {
    super.initState();
    // Re-trigger render when controller updates point data internally
    widget.controller.addListener(_handleStateChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleStateChange);
    super.dispose();
  }

  void _handleStateChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.canvasColor,
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(8.0),
      ),
      // Wrap the inner contents in a ClipRRect matching your border radius
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: GestureDetector(
          onPanStart: (details) =>
              widget.controller.addPoint(details.localPosition),
          onPanUpdate: (details) =>
              widget.controller.addPoint(details.localPosition),
          onPanEnd: (details) => widget.controller.addPoint(null),
          child: CustomPaint(
            painter: SignaturePainter(
              points: widget.controller.points,
              penColor: widget.penColor,
              strokeWidth: widget.strokeWidth,
            ),
            size: widget.padSize,
          ),
        ),
      ),
    );
  }
}
