import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebaseappdistribution/core/core.dart';

abstract class CryptoUtils {
  static bool verifySignature(
    String action,
    String issuedAt,
    String nonce,
    String receivedSignature,
  ) {
    final payload = [action, issuedAt, nonce].join('|');
    final keyBytes = utf8.encode(Constrants.signatureKey);
    final messageBytes = utf8.encode(payload);
    final hmac = Hmac(sha256, keyBytes);
    final digest = hmac.convert(messageBytes);
    final calculatedSignature = base64Encode(digest.bytes);
    return calculatedSignature == receivedSignature;
  }
}
