import 'dart:core';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:io';
import 'dart:typed_data';

class EncryptionService {
  final _secureStorage = const FlutterSecureStorage();

  // Constant keys for secure storage lookup
  static const _keyAlias = 'local_file_encryption_key';
  static const _ivAlias = 'local_file_encryption_iv';

  /// Initializes or retrieves the secret keys from Secure Storage
  Future<encrypt.Key> _getOrCreateEncryptionKey() async {
    String? storedKey = await _secureStorage.read(key: _keyAlias);

    if (storedKey == null) {
      // Generate a strong 32-byte (256-bit) key
      final key = encrypt.Key.fromSecureRandom(32);
      // Save it as a base64 string
      await _secureStorage.write(key: _keyAlias, value: key.base64);
      return key;
    }

    return encrypt.Key.fromBase64(storedKey);
  }

  /// Initializes or retrieves a static Initialization Vector (IV).
  /// Note: For maximum security per file, store a unique IV alongside each file.
  Future<encrypt.IV> _getOrCreateIV() async {
    String? storedIV = await _secureStorage.read(key: _ivAlias);

    if (storedIV == null) {
      final iv = encrypt.IV.fromSecureRandom(16); // 16 bytes for AES
      await _secureStorage.write(key: _ivAlias, value: iv.base64);
      return iv;
    }

    return encrypt.IV.fromBase64(storedIV);
  }

  /// Encrypts a file and overwrites it or saves it to a new path
  Future<void> encryptFile(File sourceFile, String targetPath) async {
    final key = await _getOrCreateEncryptionKey();
    final iv = await _getOrCreateIV();

    // Read file bytes
    Uint8List fileBytes = await sourceFile.readAsBytes();

    // Setup Encrypter with AES-CBC (or AES-GCM)
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc),
    );

    // Encrypt the bytes
    final encryptedData = encrypter.encryptBytes(fileBytes, iv: iv);

    // Save encrypted bytes to the target path
    final encryptedFile = File(targetPath);
    await encryptedFile.writeAsBytes(encryptedData.bytes);
  }

  /// Decrypts an encrypted file and returns the raw bytes
  Future<Uint8List> decryptFile(File encryptedFile) async {
    final key = await _getOrCreateEncryptionKey();
    final iv = await _getOrCreateIV();

    Uint8List encryptedBytes = await encryptedFile.readAsBytes();

    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc),
    );

    // Decrypt the bytes back to plaintext
    final decryptedBytes = encrypter.decryptBytes(
      encrypt.Encrypted(encryptedBytes),
      iv: iv,
    );

    return Uint8List.fromList(decryptedBytes);
  }
}
