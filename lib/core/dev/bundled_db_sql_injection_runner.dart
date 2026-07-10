import 'dart:io';

import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class BundledDbSqlInjectionResult {
  final int passed;
  final int failed;
  final List<String> logs;

  const BundledDbSqlInjectionResult({
    required this.passed,
    required this.failed,
    required this.logs,
  });

  bool get success => failed == 0;
}

Future<BundledDbSqlInjectionResult> runBundledDbSqlInjectionTests() async {
  final logs = <String>[];
  var passed = 0;
  var failed = 0;

  void log(String message) {
    logs.add(message);
  }

  Future<void> runCheck(String name, Future<void> Function() check) async {
    try {
      await check();
      passed++;
      log('PASS: $name');
    } catch (e, st) {
      failed++;
      log('FAIL: $name -> $e');
      log('$st');
    }
  }

  final tempDir = await getTemporaryDirectory();
  final dbCopy = File(p.join(tempDir.path, 'sqlinj_${Schema.databaseName}'));
  if (await dbCopy.exists()) {
    await dbCopy.delete();
  }

  await _copyBundledDatabase(dbCopy.path);

  final db = await openDatabase(
    dbCopy.path,
    password: Schema.databasePwd,
    version: Schema.databaseVersion,
  );

  try {
    final initialCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ${Schema.tblUser}'),
    )!;
    log('Bundled DB user count before tests: $initialCount');

    await runCheck('tblUser exists in bundled database', () async {
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name = ?",
        [Schema.tblUser],
      );
      if (tables.length != 1) {
        throw StateError('tblUser table missing');
      }
    });

    await runCheck(
      'parameterized insert stores injection payload safely',
      () async {
        const injection = "' OR '1'='1'; DROP TABLE tblUser; --";
        final malicious = UserModel(
          name: injection,
          phone: injection,
          nrc: injection,
          address: injection,
        );

        await db.insert(Schema.tblUser, malicious.toEncryptedMap());

        final tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name = ?",
          [Schema.tblUser],
        );
        if (tables.length != 1) {
          throw StateError('DROP TABLE payload affected schema');
        }

        final countAfter = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM ${Schema.tblUser}'),
        )!;
        if (countAfter != initialCount + 1) {
          throw StateError(
            'Expected ${initialCount + 1} rows, found $countAfter',
          );
        }

        final safeLookup = await db.query(
          Schema.tblUser,
          where: 'address = ?',
          whereArgs: [injection],
        );
        if (safeLookup.length != 1) {
          throw StateError('Parameterized lookup failed');
        }

        final decrypted = UserModel.fromEncryptedMap(safeLookup.first);
        if (decrypted.name != injection) {
          throw StateError('Decrypted payload mismatch');
        }
      },
    );

    await runCheck(
      'parameterized delete ignores malicious id strings',
      () async {
        const injection = '1 OR 1=1';
        final deleted = await db.rawDelete(
          'DELETE FROM ${Schema.tblUser} WHERE id = ?',
          [injection],
        );
        if (deleted != 0) {
          throw StateError('Malicious delete removed $deleted rows');
        }
      },
    );

    await runCheck(
      'seeded users remain readable after attack attempts',
      () async {
        final rows = await db.rawQuery('SELECT * FROM ${Schema.tblUser}');
        if (rows.length < initialCount) {
          throw StateError('User rows were lost');
        }

        final users = rows.map((row) => UserModel.fromEncryptedMap(row)).toList();
        if (!users.any((user) => user.name == 'Aung Aung')) {
          throw StateError('Seeded user Aung Aung not found');
        }
      },
    );
  } finally {
    await db.close();
    if (await dbCopy.exists()) {
      await dbCopy.delete();
    }
  }

  log('');
  log('SQL injection test summary: $passed passed, $failed failed');

  return BundledDbSqlInjectionResult(
    passed: passed,
    failed: failed,
    logs: logs,
  );
}

Future<void> _copyBundledDatabase(String targetPath) async {
  try {
    final bytes = await rootBundle.load(Schema.databaseAssetPath);
    final file = File(targetPath);
    await file.writeAsBytes(
      bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
      flush: true,
    );
    return;
  } catch (_) {
    final projectRoot = _findProjectRoot();
    if (projectRoot == null) {
      throw StateError('Could not load bundled database asset');
    }

    final source = File(
      p.join(projectRoot, 'assets', 'database', Schema.databaseName),
    );
    if (!await source.exists()) {
      throw StateError('Bundled database file not found at ${source.path}');
    }
    await source.copy(targetPath);
  }
}

String? _findProjectRoot() {
  var dir = Directory.current;
  for (var i = 0; i < 8; i++) {
    if (File(p.join(dir.path, 'pubspec.yaml')).existsSync()) {
      return p.normalize(dir.path);
    }
    final parent = dir.parent;
    if (parent.path == dir.path) break;
    dir = parent;
  }
  return null;
}
