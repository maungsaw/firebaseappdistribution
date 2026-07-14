import 'dart:convert';
import 'dart:io';

import 'package:firebaseappdistribution/core/service/notification/remote_wipe_crypto.dart';
import 'package:firebaseappdistribution/core/util/schema.dart';

/// Generates signed remote wipe payloads for FCM / Pushy testing.
///
/// Usage:
///
/// Use the device ID printed in debug console: `[Device] id=... model=...`
void main(List<String> args) {
  final usePlain = args.contains('--plain');
  final deviceId = _readDeviceId(args);

  if (deviceId == null || deviceId.isEmpty) {
    stderr.writeln(
      'Missing --device-id.\n'
      'Example:\n'
      '  dart run tool/generate_wipe_payload.dart --device-id=abc123def456\n'
      '  dart run tool/generate_wipe_payload.dart --device-id=abc123def456 --plain',
    );
    exit(1);
  }

  final signingSecret = RemoteWipeCrypto.signingSecretFrom(
    Schema.databasePwd,
    deviceId,
  );
  final aesKeyMaterial = RemoteWipeCrypto.aesKeyMaterialFrom(
    Schema.databasePwd,
    deviceId,
  );

  final payload = usePlain
      ? RemoteWipeCrypto.buildSignedPlainEnvelope(signingSecret: signingSecret)
      : RemoteWipeCrypto.buildEncryptedEnvelope(
          signingSecret: signingSecret,
          aesKeyMaterial: aesKeyMaterial,
        );

  stdout.writeln(
    'Remote wipe payload (${usePlain ? 'signed plain' : 'encrypted'}) '
    'for device $deviceId:',
  );
  stdout.writeln(const JsonEncoder.withIndent('  ').convert(payload));
  stdout.writeln();
  stdout.writeln('Send these keys in FCM/Pushy data payload.');
  stdout.writeln('Unsigned action=WIPE_DATA is rejected by the app.');
}

String? _readDeviceId(List<String> args) {
  for (final arg in args) {
    if (arg.startsWith('--device-id=')) {
      return arg.substring('--device-id='.length).trim();
    }
  }

  final index = args.indexOf('--device-id');
  if (index >= 0 && index + 1 < args.length) {
    return args[index + 1].trim();
  }

  return null;
}
