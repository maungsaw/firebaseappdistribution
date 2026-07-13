import 'package:firebaseappdistribution/core/service/device/device_info_service.dart';
import 'package:firebaseappdistribution/core/service/notification/remote_wipe_crypto.dart';
import 'package:firebaseappdistribution/core/service/notification/remote_wipe_security.dart';
import 'package:firebaseappdistribution/core/util/schema.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testDeviceId = 'test-device-abc12345';
  const databasePwd = 'test-db-pwd';
  final signingSecret =
      RemoteWipeCrypto.signingSecretFrom(databasePwd, testDeviceId);
  final aesKeyMaterial =
      RemoteWipeCrypto.aesKeyMaterialFrom(databasePwd, testDeviceId);

  setUp(() {
    DeviceInfoService.testDeviceId = testDeviceId;
  });

  tearDown(() {
    DeviceInfoService.clearCacheForTesting();
  });

  group('RemoteWipeCrypto', () {
    test('encrypted envelope verifies and decrypts', () {
      final issuedAt =
          DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
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
      expect(
        RemoteWipeCrypto.validateInnerCommand(inner),
        isNull,
      );
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
      final issuedAt =
          DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
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
      final deviceA =
          RemoteWipeCrypto.signingSecretFrom(Schema.databasePwd, 'device-a');
      final deviceB =
          RemoteWipeCrypto.signingSecretFrom(Schema.databasePwd, 'device-b');

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

      expect(
        RemoteWipeCrypto.validateInnerCommand(inner),
        contains('expired'),
      );
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
      final payload = await RemoteWipeSecurityService.buildEncryptedWipePayload();

      expect(payload['payload'], isNotEmpty);
      expect(payload['signature'], isNotEmpty);
      expect(
        RemoteWipeCrypto.verifySignature(
          payload['payload']!,
          payload['signature']!,
          RemoteWipeCrypto.signingSecretFrom(
            Schema.databasePwd,
            testDeviceId,
          ),
        ),
        isTrue,
      );
    });
  });
}
