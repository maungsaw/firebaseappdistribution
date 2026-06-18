import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'encryption.dart'; // Make sure this matches your EncryptionService filename

class DocumentStorageService {
  final EncryptionService _encryptionService = EncryptionService();

  /// 1. Saves a document securely into the isolated application sandbox
  Future<String> saveDocumentSecurely(File rawDownloadedFile) async {
    // Determine the unique, isolated application documents directory
    final Directory directory = await getApplicationDocumentsDirectory();
    final String originalName = rawDownloadedFile.path.split('/').last;
    final String secureFilePath = '${directory.path}/vault_$originalName.enc';

    // Encrypt and write the encrypted file data payload to disk
    await _encryptionService.encryptFile(rawDownloadedFile, secureFilePath);

    // CRITICAL COMPLIANCE: Purge the raw, unencrypted source file immediately
    if (await rawDownloadedFile.exists()) {
      await rawDownloadedFile.delete();
    }

    return secureFilePath; // Return the path so your UI state knows where it's stored
  }

  /// 2. Accesses a secure document natively inside RAM memory (Zero-Disk-Footprint)
  Future<Uint8List> accessSecureDocument(String secureFilePath) async {
    final File encryptedFile = File(secureFilePath);

    if (!await encryptedFile.exists()) {
      throw Exception("Target secure cryptographic asset not found at path.");
    }

    // Decrypt the file directly back to raw plaintext bytes in memory
    final Uint8List cleanBytes = await _encryptionService.decryptFile(
      encryptedFile,
    );

    // Return the bytes array directly.
    // ZERO temporary files are created on the device disk during this loop.
    return cleanBytes;
  }
}
