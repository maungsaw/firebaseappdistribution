import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';

class EncryptionService {
  // AES-256 Key (32 chars = 32 bytes)
  static final encrypt.Key _key = encrypt.Key.fromUtf8(
    '12345678901234567890123456789012',
  );

  // AES IV (16 chars = 16 bytes)
  static final encrypt.IV _iv = encrypt.IV.fromUtf8('1234567890123456');

  /// Encrypt file and save to target path
  static Future<void> encryptFile(File sourceFile, String targetPath) async {
    final Uint8List fileBytes = await sourceFile.readAsBytes();

    final Uint8List encryptedBytes = await compute(_encryptBytes, {
      'bytes': fileBytes,
      'key': _key.base64,
      'iv': _iv.base64,
    });

    await File(targetPath).writeAsBytes(encryptedBytes, flush: true);
  }

  /// Decrypt encrypted file and return original bytes
  static Future<Uint8List> decryptFile(File encryptedFile) async {
    final Uint8List encryptedBytes = await encryptedFile.readAsBytes();

    return compute(_decryptBytes, {
      'bytes': encryptedBytes,
      'key': _key.base64,
      'iv': _iv.base64,
    });
  }

  /// Encrypt bytes directly
  Future<Uint8List> encryptBytes(Uint8List bytes) {
    return compute(_encryptBytes, {
      'bytes': bytes,
      'key': _key.base64,
      'iv': _iv.base64,
    });
  }

  /// Decrypt bytes directly
  Future<Uint8List> decryptBytes(Uint8List bytes) {
    return compute(_decryptBytes, {
      'bytes': bytes,
      'key': _key.base64,
      'iv': _iv.base64,
    });
  }

  /// Database key
  Future<String> getDatabaseKey() async {
    return '12345678901234567890123456789012';
  }

  static encrypt.Key _keyFromPassword(String password) {
    final normalized = password.padRight(32, '0').substring(0, 32);
    return encrypt.Key.fromUtf8(normalized);
  }

  /// Encrypt plain text using a password-derived AES key.
  static String encryptText(String plainText, String password) {
    final key = _keyFromPassword(password);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc),
    );
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  /// Decrypt base64 cipher text using a password-derived AES key.
  static String decryptText(String cipherText, String password) {
    final key = _keyFromPassword(password);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc),
    );
    return encrypter.decrypt64(cipherText, iv: _iv);
  }
}

/// Top-level function required by compute()
Uint8List _encryptBytes(Map<String, dynamic> params) {
  final Uint8List bytes = params['bytes'] as Uint8List;

  final encrypt.Key key = encrypt.Key.fromBase64(params['key']);

  final encrypt.IV iv = encrypt.IV.fromBase64(params['iv']);

  final encrypter = encrypt.Encrypter(
    encrypt.AES(key, mode: encrypt.AESMode.cbc),
  );

  final encrypted = encrypter.encryptBytes(bytes, iv: iv);

  return Uint8List.fromList(encrypted.bytes);
}

/// Top-level function required by compute()
Uint8List _decryptBytes(Map<String, dynamic> params) {
  final Uint8List bytes = params['bytes'] as Uint8List;

  final encrypt.Key key = encrypt.Key.fromBase64(params['key']);

  final encrypt.IV iv = encrypt.IV.fromBase64(params['iv']);

  final encrypter = encrypt.Encrypter(
    encrypt.AES(key, mode: encrypt.AESMode.cbc),
  );

  final decrypted = encrypter.decryptBytes(encrypt.Encrypted(bytes), iv: iv);

  return Uint8List.fromList(decrypted);
}
