import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'service.dart';

enum SignatureExportFormat { png, rawRgba, points }

class SignatureSaveResult {
  final SignatureExportFormat format;
  final Uint8List? bytes;
  final List<Offset?>? points;

  SignatureSaveResult({required this.format, this.bytes, this.points});
}

/// The controller that manages canvas state and exposes action functions
class CustomSignatureController extends ChangeNotifier {
  final List<Offset?> _points = [];
  List<Offset?> get points => List.unmodifiable(_points);

  bool get isEmpty => _points.isEmpty;
  bool get isNotEmpty => _points.isNotEmpty;

  void clear() {
    _points.clear();
    notifyListeners();
  }

  void undo() {
    if (_points.isEmpty) return;

    if (_points.last == null) _points.removeLast();
    while (_points.isNotEmpty && _points.last != null) {
      _points.removeLast();
    }
    notifyListeners();
  }

  void addPoint(Offset? point) {
    _points.add(point);
    notifyListeners();
  }

  /// The action function to export the canvas data
  Future<SignatureSaveResult?> export({
    required SignatureExportFormat format,
    required Size exportSize,
    Color penColor = Colors.black,
    double strokeWidth = 3.0,
  }) async {
    if (_points.isEmpty) return null;

    if (format == SignatureExportFormat.points) {
      return SignatureSaveResult(
        format: SignatureExportFormat.points,
        points: List<Offset?>.from(_points),
      );
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final bgPaint = Paint()..color = Colors.white;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, exportSize.width, exportSize.height),
      bgPaint,
    );

    final painter = SignaturePainter(
      points: _points,
      penColor: penColor,
      strokeWidth: strokeWidth,
    );
    painter.paint(canvas, exportSize);

    final picture = recorder.endRecording();
    final ui.Image image = await picture.toImage(
      exportSize.width.toInt(),
      exportSize.height.toInt(),
    );

    final ui.ImageByteFormat byteFormat =
        format == SignatureExportFormat.rawRgba
        ? ui.ImageByteFormat.rawRgba
        : ui.ImageByteFormat.png;

    final ByteData? byteData = await image.toByteData(format: byteFormat);

    if (byteData != null) {
      return SignatureSaveResult(
        format: format,
        bytes: byteData.buffer.asUint8List(),
      );
    }
    return null;
  }
}
