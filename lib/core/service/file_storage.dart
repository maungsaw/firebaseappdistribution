import 'dart:io';
import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'encryption.dart'; // လမ်းကြောင်းများ ပေါင်းစပ်ရန်အတွက် path package ကို သုံးပါ

class FileStorageService {
  static Future<void> createFolders() async {
    final appDir = await getApplicationDocumentsDirectory();

    // Directory များ တည်ဆောက်ခြင်း
    await Directory(p.join(appDir.path, 'images')).create(recursive: true);
    await Directory(p.join(appDir.path, 'docs')).create(recursive: true);
  }

  // Type ပေါ်မူတည်ပြီး သက်ဆိုင်ရာ Folder Path ကို ပြန်ပေးခြင်း
  static Future<String> getPath(String type) async {
    final appDir = await getApplicationDocumentsDirectory();

    switch (type.toLowerCase()) {
      case 'image':
        return p.join(appDir.path, 'images');
      case 'doc':
        return p.join(appDir.path, 'docs');
      default:
        return appDir.path; // မသတ်မှတ်ထားရင် root path ပေးမယ်
    }
  }

  // File တစ်ခုရဲ့ Full Path ကို အလွယ်တကူ ရယူရန် (Helper Method)
  static Future<String> getFilePath(String type, String fileName) async {
    final folderPath = await getPath(type);
    return p.join(folderPath, fileName);
  }

  static Future<String> setDocumentSecurely(File rawDownloadedFile) async {
    // 1. FileStorageService မှတစ်ဆင့် 'docs' folder path ကို ရယူခြင်း
    final String docDir = await FileStorageService.getPath('doc');

    // 2. Original name ကို ရယူပြီး secure name သတ်မှတ်ခြင်း
    final String originalName = p.basename(rawDownloadedFile.path);
    final String secureFilePath = p.join(docDir, 'vault_$originalName.enc');

    // 3. Encrypt လုပ်ပြီး သိမ်းဆည်းခြင်း
    await EncryptionService.encryptFile(rawDownloadedFile, secureFilePath);

    // 4. CRITICAL: Raw file ကို ချက်ချင်းဖျက်ပစ်ခြင်း
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

    // Decrypt လုပ်ပြီး Memory ထဲသို့ Byte အနေနဲ့ ပြန်ပို့ပေးခြင်း
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
