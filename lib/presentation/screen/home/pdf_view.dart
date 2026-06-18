import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:firebaseappdistribution/core/core.dart'; // Contains your EncryptionService

class SecurePdfViewer extends StatefulWidget {
  final File encryptedFile;

  const SecurePdfViewer({super.key, required this.encryptedFile});

  @override
  State<SecurePdfViewer> createState() => _SecurePdfViewerState();
}

class _SecurePdfViewerState extends State<SecurePdfViewer> {
  final EncryptionService _encryptionService = EncryptionService();
  Uint8List? _decryptedBytes;
  String _errorMessage = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _decryptDocumentInMemory();
  }

  Future<void> _decryptDocumentInMemory() async {
    try {
      // 1. Process decryption completely inside RAM
      final Uint8List plainBytes = await _encryptionService.decryptFile(
        widget.encryptedFile,
      );

      setState(() {
        _decryptedBytes = plainBytes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Cryptographic decryption failed. Unauthorized access or corrupt data.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String fileName = widget.encryptedFile.path
        .split('/')
        .last
        .replaceAll('vault_', '')
        .replaceAll('.enc', '');

    return Scaffold(
      appBar: AppBar(
        title: Text(fileName, style: const TextStyle(fontSize: 16)),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : SfPdfViewer.memory(
              _decryptedBytes!,
            ), // 2. Read raw decrypted data straight from RAM array
    );
  }
}
