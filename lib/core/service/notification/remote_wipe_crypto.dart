import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

/// Pure Dart helpers for signing and encrypting remote wipe commands.
class RemoteWipeCrypto {
  static const String actionWipe = 'WIPE_DATA';
  static const Duration maxCommandAge = Duration(days: 7);
  static const Duration maxClockSkew = Duration(seconds: 60);

  static String signingSecretFrom(String databasePwd) =>
      '$databasePwd:remote-wipe-sign:v1';

  static String aesKeyMaterialFrom(String databasePwd) =>
      '$databasePwd:remote-wipe-aes:v1';

  static encrypt.Key aesKeyFromMaterial(String material) {
    final normalized = material.padRight(32, '0').substring(0, 32);
    return encrypt.Key.fromUtf8(normalized);
  }

  static String computeSignature(String message, String signingSecret) {
    final hmac = Hmac(sha256, utf8.encode(signingSecret));
    return hmac.convert(utf8.encode(message)).toString();
  }

  static bool verifySignature(
    String message,
    String signature,
    String signingSecret,
  ) {
    final expected = computeSignature(message, signingSecret);
    return _secureCompare(expected, signature.trim().toLowerCase());
  }

  /// Preferred envelope: AES-encrypted inner command + HMAC over ciphertext blob.
  static Map<String, String> buildEncryptedEnvelope({
    required String signingSecret,
    required String aesKeyMaterial,
    int? issuedAt,
    String? nonce,
  }) {
    final inner = <String, dynamic>{
      'action': actionWipe,
      'issuedAt': issuedAt ?? _unixSecondsNow(),
      'nonce': nonce ?? _randomNonce(),
    };

    final key = aesKeyFromMaterial(aesKeyMaterial);
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc),
    );
    final cipher = encrypter.encrypt(jsonEncode(inner), iv: iv);
    final payload = '${iv.base64}:${cipher.base64}';
    final signature = computeSignature(payload, signingSecret);

    return {'payload': payload, 'signature': signature};
  }

  /// Signed plaintext fields (useful for quick Pushy/FCM dashboard tests).
  static Map<String, String> buildSignedPlainEnvelope({
    required String signingSecret,
    int? issuedAt,
    String? nonce,
  }) {
    final action = actionWipe;
    final issued = (issuedAt ?? _unixSecondsNow()).toString();
    final token = nonce ?? _randomNonce();
    final canonical = _canonicalPlainMessage(action, issued, token);
    final signature = computeSignature(canonical, signingSecret);

    return {
      'action': action,
      'issuedAt': issued,
      'nonce': token,
      'signature': signature,
    };
  }

  static Map<String, dynamic>? decryptPayload(
    String payload,
    String aesKeyMaterial,
  ) {
    final parts = payload.split(':');
    if (parts.length != 2) return null;

    try {
      final key = aesKeyFromMaterial(aesKeyMaterial);
      final iv = encrypt.IV.fromBase64(parts[0]);
      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc),
      );
      final decrypted = encrypter.decrypt64(parts[1], iv: iv);
      final decoded = jsonDecode(decrypted);
      if (decoded is! Map<String, dynamic>) return null;
      return decoded;
    } catch (_) {
      return null;
    }
  }

  static String? validateInnerCommand(Map<String, dynamic> inner) {
    final action = inner['action']?.toString();
    if (action != actionWipe) {
      return 'Invalid wipe action';
    }

    final issuedAt = _parseIssuedAt(inner['issuedAt']);
    if (issuedAt == null) {
      return 'Missing or invalid issuedAt';
    }

    final ageError = _validateIssuedAt(issuedAt);
    if (ageError != null) return ageError;

    final nonce = inner['nonce']?.toString();
    if (nonce == null || nonce.length < 16) {
      return 'Missing or weak nonce';
    }

    return null;
  }

  static String canonicalPlainMessage(
    String action,
    String issuedAt,
    String nonce,
  ) =>
      _canonicalPlainMessage(action, issuedAt, nonce);

  static String _canonicalPlainMessage(
    String action,
    String issuedAt,
    String nonce,
  ) =>
      '$action|$issuedAt|$nonce';

  static int _unixSecondsNow() =>
      DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

  static int? _parseIssuedAt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  static String? _validateIssuedAt(int issuedAt) {
    final now = _unixSecondsNow();
    if (issuedAt > now + maxClockSkew.inSeconds) {
      return 'Command issued in the future';
    }
    if (now - issuedAt > maxCommandAge.inSeconds) {
      return 'Command expired';
    }
    return null;
  }

  static String _randomNonce() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  static bool _secureCompare(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }
}
