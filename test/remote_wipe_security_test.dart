import 'package:firebaseappdistribution/core/core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testDeviceId = 'test-device-abc12345';
  const databasePwd = 'test-db-pwd';
  final signingSecret = RemoteWipeCrypto.signingSecretFrom(
    databasePwd,
    testDeviceId,
  );
  final aesKeyMaterial = RemoteWipeCrypto.aesKeyMaterialFrom(
    databasePwd,
    testDeviceId,
  );

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    DeviceInfoService.testDeviceId = testDeviceId;
  });

  tearDown(() {
    DeviceInfoService.clearCacheForTesting();
  });

  group('RemoteWipeCrypto', () {
    test('encrypted envelope verifies and decrypts', () {
      final issuedAt = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      final envelope = RemoteWipeCrypto.buildEncryptedEnvelope(
        signingSecret: signingSecret,
        aesKeyMaterial: aesKeyMaterial,
        issuedAt: issuedAt,
        nonce: 'abcdefghijklmnop',
      );

      expect(
        RemoteWipeCrypto.verifySignature(
          envelope['payload']!,
          envelope['signature']!,
          signingSecret,
        ),
        isTrue,
      );

      final inner = RemoteWipeCrypto.decryptPayload(
        envelope['payload']!,
        aesKeyMaterial,
      );
      expect(inner, isNotNull);
      expect(inner!['action'], RemoteWipeCrypto.actionWipe);
      expect(inner['issuedAt'], issuedAt);
      expect(inner['nonce'], 'abcdefghijklmnop');
      expect(RemoteWipeCrypto.validateInnerCommand(inner), isNull);
    });

    test('tampered signature is rejected', () {
      final envelope = RemoteWipeCrypto.buildEncryptedEnvelope(
        signingSecret: signingSecret,
        aesKeyMaterial: aesKeyMaterial,
      );

      expect(
        RemoteWipeCrypto.verifySignature(
          envelope['payload']!,
          'deadbeef',
          signingSecret,
        ),
        isFalse,
      );
    });

    test('signed plain envelope uses canonical message', () {
      final issuedAt = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      final envelope = RemoteWipeCrypto.buildSignedPlainEnvelope(
        signingSecret: signingSecret,
        issuedAt: issuedAt,
        nonce: 'abcdefghijklmnop',
      );

      final canonical = RemoteWipeCrypto.canonicalPlainMessage(
        envelope['action']!,
        envelope['issuedAt']!,
        envelope['nonce']!,
      );

      expect(
        RemoteWipeCrypto.verifySignature(
          canonical,
          envelope['signature']!,
          signingSecret,
        ),
        isTrue,
      );
    });

    test('device-bound secrets differ per device id', () {
      final deviceA = RemoteWipeCrypto.signingSecretFrom(
        Schema.databasePwd,
        'device-a',
      );
      final deviceB = RemoteWipeCrypto.signingSecretFrom(
        Schema.databasePwd,
        'device-b',
      );

      expect(deviceA, isNot(deviceB));
      expect(deviceA, contains('device-a'));
      expect(deviceB, contains('device-b'));
    });

    test('expired command is rejected', () {
      final oldIssuedAt =
          DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000 -
          RemoteWipeCrypto.maxCommandAge.inSeconds -
          10;

      final inner = {
        'action': RemoteWipeCrypto.actionWipe,
        'issuedAt': oldIssuedAt,
        'nonce': 'abcdefghijklmnop',
      };

      expect(RemoteWipeCrypto.validateInnerCommand(inner), contains('expired'));
    });

    test('production secret derives from database pwd and device id', () {
      final secret = RemoteWipeCrypto.signingSecretFrom(
        Schema.databasePwd,
        testDeviceId,
      );
      expect(secret, contains(Schema.databasePwd));
      expect(secret, contains(testDeviceId));
      expect(secret, contains('remote-wipe-sign'));
    });
  });

  group('RemoteWipeSecurityService', () {
    test('rejects unsigned WIPE_DATA command', () async {
      final result = await RemoteWipeSecurityService.validate({
        'action': 'WIPE_DATA',
      });

      expect(result.isRejected, isTrue);
      expect(result.reason, contains('Unsigned'));
    });

    test('rejects tampered encrypted payload', () async {
      final envelope = RemoteWipeCrypto.buildEncryptedEnvelope(
        signingSecret: signingSecret,
        aesKeyMaterial: aesKeyMaterial,
      );

      final result = await RemoteWipeSecurityService.validate({
        'payload': envelope['payload'],
        'signature': 'invalid-signature',
      });

      expect(result.isRejected, isTrue);
      expect(result.reason, contains('signature'));
    });

    test('ignores unrelated notification data', () async {
      final result = await RemoteWipeSecurityService.validate({
        'screen': '/calculator',
        'title': 'Hello',
      });

      expect(result.shouldWipe, isFalse);
      expect(result.isRejected, isFalse);
    });

    test('buildEncryptedWipePayload matches device-bound secrets', () async {
      final payload =
          await RemoteWipeSecurityService.buildEncryptedWipePayload();

      expect(payload['payload'], isNotEmpty);
      expect(payload['signature'], isNotEmpty);
      expect(
        RemoteWipeCrypto.verifySignature(
          payload['payload']!,
          payload['signature']!,
          RemoteWipeCrypto.signingSecretFrom(Schema.databasePwd, testDeviceId),
        ),
        isTrue,
      );
    });

    test('server command envelope verifies Base64 signature', () async {
      final serverSecret = RemoteWipeCrypto.serverSigningSecret();
      final envelope = RemoteWipeCrypto.buildServerCommandEnvelope(
        signingSecret: serverSecret,
        deviceId: testDeviceId,
        userId: '9b8987e6-51b3-460d-99d6-549798611e30',
        commandId: 'bc0a7c6df5104dfd9ddc9929be34a60d',
        nonce: 'f874e3a7d04a4446a2deadf2bca71337',
      );

      final canonical = RemoteWipeCrypto.canonicalServerCommand(
        action: envelope['action']!,
        issuedAt: envelope['issuedAt']!,
        expiresAt: envelope['expiresAt']!,
        nonce: envelope['nonce']!,
        commandId: envelope['commandId']!,
        userId: envelope['userId']!,
        deviceId: envelope['deviceId']!,
      );

      expect(
        RemoteWipeCrypto.verifySignature(
          canonical,
          envelope['signature']!,
          serverSecret,
        ),
        isTrue,
      );

      final result = await RemoteWipeSecurityService.validate(envelope);
      expect(result.shouldWipe, isTrue);
      expect(result.commandId, envelope['commandId']);
      expect(result.userId, envelope['userId']);
    });

    test('server command rejects wrong deviceId', () async {
      final envelope = RemoteWipeCrypto.buildServerCommandEnvelope(
        signingSecret: signingSecret,
        deviceId: testDeviceId,
        userId: 'user-1',
      );
      envelope['deviceId'] = 'OTHER-DEVICE';

      // Re-sign would fail; even with old signature, device mismatch rejects.
      final result = await RemoteWipeSecurityService.validate(envelope);
      expect(result.isRejected, isTrue);
      expect(result.reason, anyOf(contains('deviceId'), contains('signature')));
    });

    test('server command rejects expired expiresAt', () {
      final error = RemoteWipeCrypto.validateServerCommandFields({
        'action': RemoteWipeCrypto.actionWipe,
        'issuedAt': DateTime.now().toUtc().toIso8601String(),
        'expiresAt': DateTime.now()
            .toUtc()
            .subtract(const Duration(minutes: 5))
            .toIso8601String(),
        'nonce': 'f874e3a7d04a4446a2deadf2bca71337',
        'commandId': 'cmd-1',
        'userId': 'user-1',
        'deviceId': testDeviceId,
      });
      expect(error, contains('expiresAt'));
    });
  });
}
