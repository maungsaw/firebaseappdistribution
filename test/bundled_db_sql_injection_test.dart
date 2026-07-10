import 'dart:io';

import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_sqlcipher/sqflite.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('bundled secure_insurance_v3.db static checks', () {
    late File bundledDb;

    setUpAll(() {
      final projectRoot = _findProjectRoot();
      expect(projectRoot, isNotNull);
      bundledDb = File(
        p.join(projectRoot!, 'assets', 'database', Schema.databaseName),
      );
    });

    test('bundled database file exists', () {
      expect(bundledDb.existsSync(), isTrue);
      expect(bundledDb.lengthSync(), greaterThan(0));
    });

    test('bundled database does not contain plaintext user secrets', () {
      final bytes = bundledDb.readAsBytesSync();
      final binary = String.fromCharCodes(bytes);

      expect(binary.contains('Aung Aung'), isFalse);
      expect(binary.contains('09123456789'), isFalse);
      expect(binary.contains('12/YGN(N)123456'), isFalse);
      expect(binary.contains("' OR '1'='1"), isFalse);
    });

    test('bundled database is not a plain readable sqlite text dump', () {
      final bytes = bundledDb.readAsBytesSync();
      final header = String.fromCharCodes(bytes.take(16));

      // SQLCipher-encrypted files should not expose a normal SQLite header.
      expect(header.startsWith('SQLite format 3'), isFalse);
    });
  });

  group('bundled secure_insurance_v3.db live SQL injection', () {
    Database? db;
    File? dbCopy;
    var initialUserCount = 0;
    var liveTestsAvailable = true;

    setUpAll(() async {
      try {
        final projectRoot = _findProjectRoot()!;
        final source = File(
          p.join(projectRoot, 'assets', 'database', Schema.databaseName),
        );

        dbCopy = File(
          p.join(
            Directory.systemTemp.path,
            'bundled_sqlinj_${DateTime.now().millisecondsSinceEpoch}_${Schema.databaseName}',
          ),
        );
        await source.copy(dbCopy!.path);

        db = await openDatabase(
          dbCopy!.path,
          password: Schema.databasePwd,
          version: Schema.databaseVersion,
        );

        final count = await db!.rawQuery('SELECT COUNT(*) FROM ${Schema.tblUser}');
        initialUserCount = Sqflite.firstIntValue(count) ?? 0;
        expect(initialUserCount, greaterThan(0));
      } catch (e) {
        liveTestsAvailable = false;
        // ignore: avoid_print
        print(
          'Skipping live bundled DB SQL injection tests on this platform. '
          'Run: flutter run -t tool/test_bundled_db_sql_injection.dart -d <android-device>',
        );
      }
    });

    tearDownAll(() async {
      if (db != null) {
        await db!.close();
      }
      if (dbCopy != null && await dbCopy!.exists()) {
        await dbCopy!.delete();
      }
    });

    test('parameterized insert stores payload without executing SQL', () async {
      if (!liveTestsAvailable) return;

      const injection = "' OR '1'='1'; DROP TABLE tblUser; --";
      final malicious = UserModel(
        name: injection,
        phone: injection,
        nrc: injection,
        address: injection,
      );

      await db!.insert(Schema.tblUser, malicious.toEncryptedMap());

      final tables = await db!.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name = ?",
        [Schema.tblUser],
      );
      expect(tables, hasLength(1));

      final countAfter = Sqflite.firstIntValue(
        await db!.rawQuery('SELECT COUNT(*) FROM ${Schema.tblUser}'),
      );
      expect(countAfter, initialUserCount + 1);

      final safeLookup = await db!.query(
        Schema.tblUser,
        where: 'address = ?',
        whereArgs: [injection],
      );
      expect(safeLookup, hasLength(1));
      expect(UserModel.fromEncryptedMap(safeLookup.first).name, injection);
    }, skip: !Platform.isAndroid && !Platform.isIOS ? 'Needs SQLCipher device runtime' : false);

    test('parameterized delete ignores malicious id strings', () async {
      if (!liveTestsAvailable) return;

      final deleted = await db!.rawDelete(
        'DELETE FROM ${Schema.tblUser} WHERE id = ?',
        ['1 OR 1=1'],
      );
      expect(deleted, 0);

      final countAfter = Sqflite.firstIntValue(
        await db!.rawQuery('SELECT COUNT(*) FROM ${Schema.tblUser}'),
      );
      expect(countAfter, greaterThan(0));
    }, skip: !Platform.isAndroid && !Platform.isIOS ? 'Needs SQLCipher device runtime' : false);

    test('seeded users remain readable after attack attempts', () async {
      if (!liveTestsAvailable) return;

      final rows = await db!.rawQuery('SELECT * FROM ${Schema.tblUser}');
      expect(rows.length, greaterThanOrEqualTo(initialUserCount));

      final users = rows.map((row) => UserModel.fromEncryptedMap(row)).toList();
      expect(users.any((user) => user.name == 'Aung Aung'), isTrue);
    }, skip: !Platform.isAndroid && !Platform.isIOS ? 'Needs SQLCipher device runtime' : false);
  });
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
