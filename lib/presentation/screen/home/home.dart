import 'dart:io';
import 'package:firebaseappdistribution/core/core.dart';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'pdf_view.dart'; // Contains SecurePdfViewer and your storage structures

class DocumentVaultView extends StatefulWidget {
  const DocumentVaultView({super.key});

  @override
  State<DocumentVaultView> createState() => _DocumentVaultViewState();
}

class _DocumentVaultViewState extends State<DocumentVaultView> {
  final DocumentStorageService _storageService = DocumentStorageService();

  bool _isProcessing = false;
  String _operationStatus = 'Secure Vault Ready';
  String _securedFilePath = '';

  /// METHOD 1: Isolated File Picking Operation using file_selector
  Future<File?> _handleFileSelection() async {
    try {
      const XTypeGroup typeGroup = XTypeGroup(
        label: 'All Documents',
        extensions: <String>['pdf', 'doc', 'docx', 'txt', 'png', 'jpg', 'jpeg'],
      );

      final XFile? result = await openFile(
        acceptedTypeGroups: <XTypeGroup>[typeGroup],
      );

      if (result != null) {
        return File(result.path);
      }
    } catch (e) {
      _showSnackBarError('System File Picker failed to initialize.');
    }
    return null;
  }

  /// METHOD 2: Core Orchestration (The IS Workflow via DocumentStorageService)
  Future<void> _executeSecureIngestion() async {
    // 1. Pick the raw asset
    final File? rawFile = await _handleFileSelection();
    if (rawFile == null) {
      setState(() => _operationStatus = 'Ingestion cancelled by user.');
      return;
    }

    // 2. Set loading state immediately
    setState(() {
      _isProcessing = true;
      _operationStatus = 'Encrypting document payload securely...';
      _securedFilePath = '';
    });

    try {
      // 3. Delegate execution directly to your secure storage service pipeline
      // This encrypts, transfers to application container sandbox, and destroys the source file.
      final String encryptedDestinationPath = await _storageService
          .saveDocumentSecurely(rawFile);

      setState(() {
        _isProcessing = false;
        _operationStatus =
            'Document encrypted and locked into secure storage successfully.';
        _securedFilePath = encryptedDestinationPath;
      });
    } catch (cryptoError) {
      setState(() {
        _isProcessing = false;
        _operationStatus = 'Security Ingestion Failure.';
      });
      _showSnackBarError(
        'Encryption subsystem threw a cryptographic block error.',
      );
    }
  }

  void _showSnackBarError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Local Data Vault (IS Standard)'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Display Dashboard Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Icon(
                      _securedFilePath.isEmpty
                          ? Icons.lock_open_outlined
                          : Icons.gpp_good,
                      size: 72,
                      color: _securedFilePath.isEmpty
                          ? Colors.amber[700]
                          : Colors.green[700],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _operationStatus,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                    if (_securedFilePath.isNotEmpty) ...[
                      const Divider(height: 32),
                      const Text(
                        'AES-256 Verified Storage Path:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _securedFilePath,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
                            fontFamily: 'monospace',
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SecurePdfViewer(
                                encryptedFile: File(_securedFilePath),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('View Decrypted PDF (In-Memory)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[700],
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Action Trigger
            _isProcessing
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
                    onPressed: _executeSecureIngestion,
                    icon: const Icon(Icons.add_moderator),
                    label: const Text('Ingest & Encrypt New Document'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[900],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
