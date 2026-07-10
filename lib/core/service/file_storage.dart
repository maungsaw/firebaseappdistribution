import 'dart:io';
import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'encryption/service.dart';

class FileStorageService {
  static Future<void> createFolders() async {
    final appDir = await getApplicationDocumentsDirectory();
    await Directory(p.join(appDir.path, 'images')).create(recursive: true);
    await Directory(p.join(appDir.path, 'docs')).create(recursive: true);
  }

  static Future<String> getPath(String type) async {
    final appDir = await getApplicationDocumentsDirectory();

    switch (type.toLowerCase()) {
      case 'image':
        return p.join(appDir.path, 'images');
      case 'doc':
        return p.join(appDir.path, 'docs');
      default:
        return appDir.path;
    }
  }

  static Future<String> getFilePath(String type, String fileName) async {
    final folderPath = await getPath(type);
    return p.join(folderPath, fileName);
  }

  static Future<String> setDocumentSecurely(File rawDownloadedFile) async {
    final String docDir = await FileStorageService.getPath('doc');
    final String originalName = p.basename(rawDownloadedFile.path);
    final String secureFilePath = p.join(docDir, 'vault_$originalName.enc');
    await EncryptionService.encryptFile(rawDownloadedFile, secureFilePath);
    if (await rawDownloadedFile.exists()) {
      await rawDownloadedFile.delete();
    }

    return secureFilePath;
  }

  static Future<Uint8List> getSecureDocument(String secureFilePath) async {
    final File encryptedFile = File(secureFilePath);

    if (!await encryptedFile.exists()) {
      throw Exception("Target secure cryptographic asset not found at path.");
    }
    final Uint8List cleanBytes = await EncryptionService.decryptFile(
      encryptedFile,
    );

    return cleanBytes;
  }

  static Future<File?> pickFile(List<String> extensions) async {
    try {
      XTypeGroup typeGroup = XTypeGroup(
        label: 'All Documents',
        extensions: extensions,
      );

      final XFile? result = await openFile(
        acceptedTypeGroups: <XTypeGroup>[typeGroup],
      );

      if (result != null) {
        return File(result.path);
      }
    } catch (e) {
      // Caught gracefully; UI handles errors through state mutations
      debugPrint("Pick error -> e");
    }
    return null;
  }
}
