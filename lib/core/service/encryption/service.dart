import 'dart:io';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebaseappdistribution/core/util/schema.dart';
import 'package:flutter/foundation.dart';

import 'user_field.dart';

class EncryptionService {
  // AES-256 Key (32 chars = 32 bytes) for file encryption
  static final encrypt.Key _key = encrypt.Key.fromUtf8(
    '12345678901234567890123456789012',
  );

  // AES IV (16 chars = 16 bytes) for file encryption
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

  /// Encrypt a user column value with a per-column derived key and random IV.
  /// Stored format: `iv.base64:cipher.base64`
  static String encryptField(String plainText, UserField field) {
    if (plainText.isEmpty) return plainText;

    final key = _deriveColumnKey(field);
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc),
    );
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  /// Decrypt a user column value encrypted with [encryptField].
  static String decryptField(String encryptedString, UserField field) {
    if (encryptedString.isEmpty) return encryptedString;

    if (!encryptedString.contains(':')) {
      return _decryptLegacyField(encryptedString);
    }

    final parts = encryptedString.split(':');
    if (parts.length != 2) return encryptedString;

    final key = _deriveColumnKey(field);
    final iv = encrypt.IV.fromBase64(parts[0]);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc),
    );
    return encrypter.decrypt64(parts[1], iv: iv);
  }

  static encrypt.Key _deriveColumnKey(UserField field) {
    final material = '${Schema.databasePwd}:tblUser:${field.name}';
    final normalized = material.padRight(32, '0').substring(0, 32);
    return encrypt.Key.fromUtf8(normalized);
  }

  static String _decryptLegacyField(String cipherText) {
    final key = _deriveLegacyKey(Schema.databasePwd);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc),
    );
    return encrypter.decrypt64(cipherText, iv: _iv);
  }

  static encrypt.Key _deriveLegacyKey(String password) {
    final normalized = password.padRight(32, '0').substring(0, 32);
    return encrypt.Key.fromUtf8(normalized);
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
