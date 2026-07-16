import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebaseappdistribution/core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const sigB64 = '83nI3hou1MzTiUQn0kG9IlqaHnHaq/BZFhWEfdC3gMI=';
  const action = 'WIPE_DATA';
  const issuedAt = '2026-07-16T05:29:42.9259874Z';
  const commandId = '3439511369e64669b38deff39b93143d';
  const userId = '9b8987e6-51b3-460d-99d6-549798611e30';
  const nonce = '29a26c61a0ae43ff9fdb53c2af3650af';
  const deviceId = 'BP4A.251205.006';
  const expiresAt = '2026-07-16T05:44:42.9259874Z';

  String hmacB64(String msg, List<int> keyBytes) =>
      base64.encode(Hmac(sha256, keyBytes).convert(utf8.encode(msg)).bytes);

  List<List<T>> permutations<T>(List<T> items) {
    if (items.length <= 1) return [items];
    final result = <List<T>>[];
    for (var i = 0; i < items.length; i++) {
      final rest = [...items.sublist(0, i), ...items.sublist(i + 1)];
      for (final p in permutations(rest)) {
        result.add([items[i], ...p]);
      }
    }
    return result;
  }

  test('probe backend wipe signature - permutations and key variants', () {
    final serverKey = RemoteWipeCrypto.serverSigningSecret();
    final decoded = base64.decode(serverKey);
    final keys = <List<int>>[
      utf8.encode(serverKey),
      decoded,
      sha256.convert(utf8.encode(serverKey)).bytes,
      sha256.convert(decoded).bytes,
      if (decoded.length >= 32) decoded.sublist(0, 32),
    ];

    final parts = [
      action,
      issuedAt,
      expiresAt,
      nonce,
      commandId,
      userId,
      deviceId,
    ];
    final separators = ['|', ':', ',', ';', '\n', ''];

    final hits = <String>[];
    for (final sep in separators) {
      for (final perm in permutations(parts)) {
        final msg = perm.join(sep);
        for (var ki = 0; ki < keys.length; ki++) {
          if (hmacB64(msg, keys[ki]) == sigB64) {
            hits.add('sep="$sep" key=$ki msg=$msg');
          }
        }
      }
    }

    // Bad but common: sha256(message + secret) or sha256(secret + message)
    for (final perm in permutations(parts)) {
      final msg = perm.join('|');
      final combos = [
        '$msg$serverKey',
        '$serverKey$msg',
        '$msg${utf8.decode(decoded)}',
      ];
      for (final combo in combos) {
        final digest = base64.encode(sha256.convert(utf8.encode(combo)).bytes);
        if (digest == sigB64) hits.add('plainSha msg=$combo');
      }
    }

    // ignore: avoid_print
    print('hits (${hits.length}):');
    for (final hit in hits.take(20)) {
      // ignore: avoid_print
      print(hit);
    }

    expect(hits, isNotEmpty);
  });
}
