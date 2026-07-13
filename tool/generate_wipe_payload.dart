import 'dart:convert';
import 'dart:io';

import 'package:firebaseappdistribution/core/service/notification/remote_wipe_crypto.dart';
import 'package:firebaseappdistribution/core/util/schema.dart';

/// Generates signed remote wipe payloads for FCM / Pushy testing.
///
/// Usage:
///   dart run tool/generate_wipe_payload.dart
///   dart run tool/generate_wipe_payload.dart --plain
void main(List<String> args) {
  final usePlain = args.contains('--plain');
  final signingSecret =
      RemoteWipeCrypto.signingSecretFrom(Schema.databasePwd);
  final aesKeyMaterial =
      RemoteWipeCrypto.aesKeyMaterialFrom(Schema.databasePwd);

  final payload = usePlain
      ? RemoteWipeCrypto.buildSignedPlainEnvelope(signingSecret: signingSecret)
      : RemoteWipeCrypto.buildEncryptedEnvelope(
          signingSecret: signingSecret,
          aesKeyMaterial: aesKeyMaterial,
        );

  stdout.writeln('Remote wipe payload (${usePlain ? 'signed plain' : 'encrypted'}):');
  stdout.writeln(const JsonEncoder.withIndent('  ').convert(payload));
  stdout.writeln();
  stdout.writeln('Send these keys in FCM/Pushy data payload.');
  stdout.writeln('Unsigned action=WIPE_DATA is rejected by the app.');
}
