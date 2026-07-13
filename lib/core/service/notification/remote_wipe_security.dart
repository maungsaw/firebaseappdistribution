import 'package:firebaseappdistribution/core/service/cache.dart';
import 'package:firebaseappdistribution/core/service/device/device_info_service.dart';
import 'package:firebaseappdistribution/core/service/notification/remote_wipe_crypto.dart';
import 'package:firebaseappdistribution/core/util/schema.dart';
import 'package:flutter/foundation.dart';

enum RemoteWipeValidationStatus { notWipeCommand, rejected, accepted }

class RemoteWipeValidationResult {
  const RemoteWipeValidationResult._(this.status, [this.reason]);

  final RemoteWipeValidationStatus status;
  final String? reason;

  bool get shouldWipe => status == RemoteWipeValidationStatus.accepted;
  bool get isRejected => status == RemoteWipeValidationStatus.rejected;

  factory RemoteWipeValidationResult.notWipeCommand() =>
      const RemoteWipeValidationResult._(
        RemoteWipeValidationStatus.notWipeCommand,
      );

  factory RemoteWipeValidationResult.rejected(String reason) =>
      RemoteWipeValidationResult._(
        RemoteWipeValidationStatus.rejected,
        reason,
      );

  factory RemoteWipeValidationResult.accepted() =>
      const RemoteWipeValidationResult._(RemoteWipeValidationStatus.accepted);
}

class _RemoteWipeSecrets {
  const _RemoteWipeSecrets({
    required this.signingSecret,
    required this.aesKeyMaterial,
  });

  final String signingSecret;
  final String aesKeyMaterial;
}

class RemoteWipeSecurityService {
  static const _nonceCacheKey = 'remote-wipe-used-nonces';

  static Future<_RemoteWipeSecrets> _resolveSecrets() async {
    final deviceId = await DeviceInfoService.getDeviceId();
    return _RemoteWipeSecrets(
      signingSecret:
          RemoteWipeCrypto.signingSecretFrom(Schema.databasePwd, deviceId),
      aesKeyMaterial:
          RemoteWipeCrypto.aesKeyMaterialFrom(Schema.databasePwd, deviceId),
    );
  }

  /// Builds the encrypted envelope for FCM/Pushy `data` payloads.
  static Future<Map<String, String>> buildEncryptedWipePayload() async {
    final secrets = await _resolveSecrets();
    return RemoteWipeCrypto.buildEncryptedEnvelope(
      signingSecret: secrets.signingSecret,
      aesKeyMaterial: secrets.aesKeyMaterial,
    );
  }

  /// Builds signed plaintext fields for dashboard testing.
  static Future<Map<String, String>> buildSignedPlainWipePayload() async {
    final secrets = await _resolveSecrets();
    return RemoteWipeCrypto.buildSignedPlainEnvelope(
      signingSecret: secrets.signingSecret,
    );
  }

  static Future<RemoteWipeValidationResult> validate(
    Map<String, dynamic> raw,
  ) async {
    final data = raw.map((key, value) => MapEntry(key, value.toString()));

    if (data.containsKey('payload') && data.containsKey('signature')) {
      return _validateEncryptedEnvelope(data);
    }

    if (data.containsKey('signature') &&
        data['action'] == RemoteWipeCrypto.actionWipe) {
      return _validateSignedPlainEnvelope(data);
    }

    if (data['action'] == RemoteWipeCrypto.actionWipe) {
      return RemoteWipeValidationResult.rejected(
        'Unsigned wipe command rejected',
      );
    }

    return RemoteWipeValidationResult.notWipeCommand();
  }

  static Future<RemoteWipeValidationResult> _validateEncryptedEnvelope(
    Map<String, String> data,
  ) async {
    late final _RemoteWipeSecrets secrets;
    try {
      secrets = await _resolveSecrets();
    } catch (error) {
      return RemoteWipeValidationResult.rejected(
        'Unable to resolve device-bound wipe secrets: $error',
      );
    }

    final payload = data['payload']!;
    final signature = data['signature']!;

    if (!RemoteWipeCrypto.verifySignature(
      payload,
      signature,
      secrets.signingSecret,
    )) {
      return RemoteWipeValidationResult.rejected('Invalid wipe signature');
    }

    final inner = RemoteWipeCrypto.decryptPayload(
      payload,
      secrets.aesKeyMaterial,
    );
    if (inner == null) {
      return RemoteWipeValidationResult.rejected('Unable to decrypt wipe payload');
    }

    final innerError = RemoteWipeCrypto.validateInnerCommand(inner);
    if (innerError != null) {
      return RemoteWipeValidationResult.rejected(innerError);
    }

    return _checkNonceAndAccept(inner['nonce']!.toString());
  }

  static Future<RemoteWipeValidationResult> _validateSignedPlainEnvelope(
    Map<String, String> data,
  ) async {
    late final _RemoteWipeSecrets secrets;
    try {
      secrets = await _resolveSecrets();
    } catch (error) {
      return RemoteWipeValidationResult.rejected(
        'Unable to resolve device-bound wipe secrets: $error',
      );
    }

    final action = data['action']!;
    final issuedAt = data['issuedAt']!;
    final nonce = data['nonce']!;
    final signature = data['signature']!;

    final canonical = RemoteWipeCrypto.canonicalPlainMessage(
      action,
      issuedAt,
      nonce,
    );
    if (!RemoteWipeCrypto.verifySignature(
      canonical,
      signature,
      secrets.signingSecret,
    )) {
      return RemoteWipeValidationResult.rejected('Invalid wipe signature');
    }

    final innerError = RemoteWipeCrypto.validateInnerCommand({
      'action': action,
      'issuedAt': issuedAt,
      'nonce': nonce,
    });
    if (innerError != null) {
      return RemoteWipeValidationResult.rejected(innerError);
    }

    return _checkNonceAndAccept(nonce);
  }

  static Future<RemoteWipeValidationResult> _checkNonceAndAccept(
    String nonce,
  ) async {
    if (await _isNonceUsed(nonce)) {
      return RemoteWipeValidationResult.rejected('Replayed wipe nonce');
    }

    await _markNonceUsed(nonce);
    return RemoteWipeValidationResult.accepted();
  }

  static Future<bool> _isNonceUsed(String nonce) async {
    final raw = await LocalCacheService.read(_nonceCacheKey);
    if (raw == null || raw.isEmpty) return false;
    return raw.split(',').contains(nonce);
  }

  static Future<void> _markNonceUsed(String nonce) async {
    final raw = await LocalCacheService.read(_nonceCacheKey);
    final list = raw?.split(',').where((entry) => entry.isNotEmpty).toList() ??
        <String>[];
    list.add(nonce);
    while (list.length > 100) {
      list.removeAt(0);
    }
    await LocalCacheService.write(_nonceCacheKey, list.join(','));
  }
}

void logRemoteWipeRejection(String reason) {
  debugPrint('Remote wipe blocked: $reason');
}
