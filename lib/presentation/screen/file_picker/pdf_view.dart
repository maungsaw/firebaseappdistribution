import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SecurePdfViewer extends StatelessWidget {
  final Uint8List decryptedBytes;

  final Function()? onClose;
  const SecurePdfViewer({
    super.key,
    required this.decryptedBytes,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SfPdfViewer.memory(decryptedBytes),
        Align(
          alignment: Alignment.topRight,
          child: IconButton.filledTonal(
            color: Colors.blueGrey[900],
            focusColor: Colors.green,
            splashColor: Colors.yellow,
            onPressed: () => onClose?.call(),
            icon: const Icon(Icons.close),
          ),
        ),
      ], // 2. Read raw decrypted data straight from RAM array
    );
  }
}
