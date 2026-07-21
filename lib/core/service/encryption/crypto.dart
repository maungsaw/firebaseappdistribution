import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:firebaseappdistribution/core/core.dart';

abstract class CryptoUtils {
  // Existing HMAC verification method
  static bool verifySignature(
    String action,
    String issuedAt,
    String nonce,
    String receivedSignature,
  ) {
    final payload = [action, issuedAt, nonce].join('|');
    final keyBytes = utf8.encode(
      Constants.signatureKey,
    ); // Replace with Constants.signatureKey
    final messageBytes = utf8.encode(payload);
    final hmac = Hmac(sha256, keyBytes);
    final digest = hmac.convert(messageBytes);
    final calculatedSignature = base64Encode(digest.bytes);
    return calculatedSignature == receivedSignature;
  }

  // =========================================================================
  // CORE SHA-256 STREAM CIPHER (CTR MODE - NO NONCE)
  // Uses SHA-256( Key + Counter ) to construct keystream and XORs data.
  // =========================================================================
  static Uint8List _processSha256Ctr(List<int> inputBytes, String key) {
    final keyBytes = utf8.encode(key);
    final result = Uint8List(inputBytes.length);

    int offset = 0;
    int counter = 0;

    while (offset < inputBytes.length) {
      // 1. Create a 4-byte big-endian counter buffer
      final counterBytes = Uint8List(4)
        ..buffer.asByteData().setUint32(0, counter, Endian.big);

      // 2. Keystream Block = SHA256( Key + Counter )
      final digest = sha256.convert([...keyBytes, ...counterBytes]);
      final keystreamBlock = digest.bytes; // 32 bytes

      // 3. XOR input bytes with keystream block
      final bytesToXor = (inputBytes.length - offset < 32)
          ? inputBytes.length - offset
          : 32;

      for (int i = 0; i < bytesToXor; i++) {
        result[offset + i] = inputBytes[offset + i] ^ keystreamBlock[i];
      }

      offset += bytesToXor;
      counter++;
    }

    return result;
  }

  // ==========================================
  // 1. TEXT ENCRYPTION / DECRYPTION
  // ==========================================

  /// Encrypts text using SHA-256 and outputs Base64.
  static String encryptText(String plainText, String key) {
    final bytes = utf8.encode(plainText);
    final encrypted = _processSha256Ctr(bytes, key);
    return base64Encode(encrypted);
  }

  /// Decrypts a Base64 string back to plain text.
  static String decryptText(String base64Text, String key) {
    final bytes = base64Decode(base64Text);
    final decrypted = _processSha256Ctr(bytes, key);
    return utf8.decode(decrypted);
  }

  // ==========================================
  // 2. IMAGE / BYTE ENCRYPTION & DECRYPTION
  // ==========================================

  /// Encrypts raw image or binary bytes.
  static Uint8List encryptBytes(Uint8List bytes, String key) {
    return _processSha256Ctr(bytes, key);
  }

  /// Decrypts raw image or binary bytes.
  static Uint8List decryptBytes(Uint8List encryptedBytes, String key) {
    return _processSha256Ctr(encryptedBytes, key);
  }

  // ==========================================
  // 3. FILE ENCRYPTION / DECRYPTION (DISK I/O)
  // ==========================================

  /// Reads a file from disk, encrypts it, and saves the output.
  static Future<File> encryptFile({
    required File inputFile,
    required File outputFile,
    required String key,
  }) async {
    final bytes = await inputFile.readAsBytes();
    final encrypted = _processSha256Ctr(bytes, key);
    return await outputFile.writeAsBytes(encrypted);
  }

  /// Reads an encrypted file from disk, decrypts it, and saves the output.
  static Future<File> decryptFile({
    required File inputFile,
    required File outputFile,
    required String key,
  }) async {
    final bytes = await inputFile.readAsBytes();
    final decrypted = _processSha256Ctr(bytes, key);
    return await outputFile.writeAsBytes(decrypted);
  }
}
