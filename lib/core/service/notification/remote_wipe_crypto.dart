import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

/// Pure Dart helpers for signing and encrypting remote wipe commands.
class RemoteWipeCrypto {
  static const String actionWipe = 'WIPE_DATA';
  static const Duration maxCommandAge = Duration(days: 7);
  static const Duration maxClockSkew = Duration(seconds: 60);

  /// Shared HMAC key from Agent App API — must match backend exactly.
  static const String backendSharedSigningKey =
      'UC9+Aic/xe97krhij8zsU8neNKo0qNheVT6wF2VHn73648qT5zW3J8ngoLlU1u3z';

  /// Device-bound secret (legacy encrypted / local test envelopes).
  static String signingSecretFrom(String databasePwd, String deviceId) =>
      '$databasePwd:$deviceId:remote-wipe-sign:v1';

  /// Prefer [backendSharedSigningKey] for server push commands.
  static String serverSigningSecret() => backendSharedSigningKey;

  static String aesKeyMaterialFrom(String databasePwd, String deviceId) =>
      '$databasePwd:$deviceId:remote-wipe-aes:v1';

  static encrypt.Key aesKeyFromMaterial(String material) {
    final normalized = material.padRight(32, '0').substring(0, 32);
    return encrypt.Key.fromUtf8(normalized);
  }

  static Digest _hmacDigest(String message, String signingSecret) {
    final hmac = Hmac(sha256, utf8.encode(signingSecret));
    return hmac.convert(utf8.encode(message));
  }

  static Digest _hmacDigestWithKeyBytes(String message, List<int> keyBytes) {
    final hmac = Hmac(sha256, keyBytes);
    return hmac.convert(utf8.encode(message));
  }

  /// Hex digest (legacy / encrypted envelope).
  static String computeSignature(String message, String signingSecret) =>
      _hmacDigest(message, signingSecret).toString();

  /// Base64 digest (Agent App API push payload).
  static String computeSignatureBase64(String message, String signingSecret) =>
      base64.encode(_hmacDigest(message, signingSecret).bytes);

  static bool verifySignature(
    String message,
    String signature,
    String signingSecret,
  ) {
    final provided = signature.trim();
    if (provided.isEmpty) return false;

    if (_matchesDigest(message, provided, utf8.encode(signingSecret))) {
      return true;
    }

    // Some backends store the shared key as Base64 key material.
    try {
      final keyBytes = base64.decode(signingSecret);
      if (_matchesDigest(message, provided, keyBytes)) return true;
    } catch (_) {
      // Not valid Base64 — UTF-8 path above is enough.
    }

    return false;
  }

  static bool _matchesDigest(
    String message,
    String provided,
    List<int> keyBytes,
  ) {
    final digest = _hmacDigestWithKeyBytes(message, keyBytes);
    final expectedHex = digest.toString();
    if (_secureCompare(expectedHex, provided.toLowerCase())) return true;
    final expectedB64 = base64.encode(digest.bytes);
    if (_secureCompare(expectedB64, provided)) return true;
    // Base64URL without padding (common in some APIs).
    final expectedB64Url = base64Url.encode(digest.bytes).replaceAll('=', '');
    final providedNorm = provided.replaceAll('-', '+').replaceAll('_', '/');
    try {
      final providedBytes = base64.decode(_padBase64(providedNorm));
      return _secureCompareBytes(digest.bytes, providedBytes);
    } catch (_) {
      return _secureCompare(expectedB64Url, provided.replaceAll('=', ''));
    }
  }

  static String _padBase64(String value) {
    final mod = value.length % 4;
    if (mod == 0) return value;
    return value.padRight(value.length + (4 - mod), '=');
  }

  static bool _secureCompareBytes(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
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

  /// Backend / Agent App API push command (ISO timestamps + Base64 HMAC).
  static Map<String, String> buildServerCommandEnvelope({
    required String signingSecret,
    required String deviceId,
    required String userId,
    String? commandId,
    DateTime? issuedAt,
    DateTime? expiresAt,
    String? nonce,
  }) {
    final issued = (issuedAt ?? DateTime.now().toUtc()).toUtc();
    final expires =
        (expiresAt ?? issued.add(const Duration(minutes: 15))).toUtc();
    final issuedRaw = _formatIsoUtc(issued);
    final expiresRaw = _formatIsoUtc(expires);
    final token = nonce ?? _randomNonce();
    final cmd = commandId ?? _randomNonce();
    final canonical = canonicalServerCommand(
      action: actionWipe,
      issuedAt: issuedRaw,
      expiresAt: expiresRaw,
      nonce: token,
      commandId: cmd,
      userId: userId,
      deviceId: deviceId,
    );

    return {
      'action': actionWipe,
      'issuedAt': issuedRaw,
      'expiresAt': expiresRaw,
      'nonce': token,
      'commandId': cmd,
      'userId': userId,
      'deviceId': deviceId,
      'signature': computeSignatureBase64(canonical, signingSecret),
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

    final issuedAt = parseTimestamp(inner['issuedAt']);
    if (issuedAt == null) {
      return 'Missing or invalid issuedAt';
    }

    final ageError = validateIssuedAt(issuedAt);
    if (ageError != null) return ageError;

    final nonce = inner['nonce']?.toString();
    if (nonce == null || nonce.length < 16) {
      return 'Missing or weak nonce';
    }

    return null;
  }

  /// Validates Agent App API server command fields (excl. signature).
  static String? validateServerCommandFields(Map<String, String> data) {
    if (data['action'] != actionWipe) return 'Invalid wipe action';

    final issuedAt = parseTimestamp(data['issuedAt']);
    if (issuedAt == null) return 'Missing or invalid issuedAt';

    final issuedError = validateIssuedAt(issuedAt);
    if (issuedError != null) return issuedError;

    final expiresAt = parseTimestamp(data['expiresAt']);
    if (expiresAt == null) return 'Missing or invalid expiresAt';
    final now = DateTime.now().toUtc();
    if (now.isAfter(expiresAt.add(maxClockSkew))) {
      return 'Command expired (expiresAt)';
    }

    final nonce = data['nonce'];
    if (nonce == null || nonce.length < 16) {
      return 'Missing or weak nonce';
    }

    final commandId = data['commandId'];
    if (commandId == null || commandId.isEmpty) {
      return 'Missing commandId';
    }

    final userId = data['userId'];
    if (userId == null || userId.isEmpty) {
      return 'Missing userId';
    }

    final deviceId = data['deviceId'];
    if (deviceId == null || deviceId.isEmpty) {
      return 'Missing deviceId';
    }

    return null;
  }

  static String canonicalPlainMessage(
    String action,
    String issuedAt,
    String nonce,
  ) =>
      _canonicalPlainMessage(action, issuedAt, nonce);

  /// Canonical string signed by Agent App API for wipe push commands.
  ///
  /// Order must stay in sync with the backend HMAC input.
  static String canonicalServerCommand({
    required String action,
    required String issuedAt,
    required String expiresAt,
    required String nonce,
    required String commandId,
    required String userId,
    required String deviceId,
  }) =>
      '$action|$issuedAt|$expiresAt|$nonce|$commandId|$userId|$deviceId';

  static String _canonicalPlainMessage(
    String action,
    String issuedAt,
    String nonce,
  ) =>
      '$action|$issuedAt|$nonce';

  static int _unixSecondsNow() =>
      DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

  /// Accepts unix seconds (int/string) or ISO-8601 timestamps.
  static DateTime? parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value.toUtc();
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value * 1000, isUtc: true);
    }
    final raw = value.toString().trim();
    if (raw.isEmpty) return null;

    final asInt = int.tryParse(raw);
    if (asInt != null) {
      // Heuristic: 10-digit unix seconds vs ms.
      if (asInt > 9999999999) {
        return DateTime.fromMillisecondsSinceEpoch(asInt, isUtc: true);
      }
      return DateTime.fromMillisecondsSinceEpoch(asInt * 1000, isUtc: true);
    }

    return DateTime.tryParse(raw)?.toUtc();
  }

  static String? validateIssuedAt(DateTime issuedAt) {
    final now = DateTime.now().toUtc();
    if (issuedAt.isAfter(now.add(maxClockSkew))) {
      return 'Command issued in the future';
    }
    if (now.difference(issuedAt) > maxCommandAge) {
      return 'Command expired';
    }
    return null;
  }

  static String _formatIsoUtc(DateTime value) =>
      value.toUtc().toIso8601String();

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
