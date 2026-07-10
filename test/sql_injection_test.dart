import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('SQL injection resistance', () {
    test('encrypted user fields round-trip malicious payloads as data', () {
      const payloads = [
        "' OR '1'='1",
        "'; DROP TABLE tblUser; --",
        "1 UNION SELECT * FROM tblUser",
        "Robert'); DROP TABLE tblUser;--",
      ];

      for (final payload in payloads) {
        final user = UserModel(
          name: payload,
          phone: payload,
          nrc: payload,
          address: payload,
        );

        final encrypted = user.toEncryptedMap();
        expect(encrypted['name'], isNot(equals(payload)));
        expect(encrypted['phone'], isNot(equals(payload)));
        expect(encrypted['nrc'], isNot(equals(payload)));

        final decrypted = UserModel.fromEncryptedMap(encrypted);
        expect(decrypted.name, payload);
        expect(decrypted.phone, payload);
        expect(decrypted.nrc, payload);
        expect(decrypted.address, payload);
      }
    });

    test('parameterized insert treats injection payload as literal value', () async {
      final db = await openDatabase(
        inMemoryDatabasePath,
        version: 1,
        onCreate: (database, version) async {
          await database.execute('''
            CREATE TABLE tblUser (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              address TEXT NOT NULL
            )
          ''');
        },
      );

      const injection = "' OR '1'='1";

      await db.insert('tblUser', {
        'name': EncryptionService.encryptField(injection, UserField.name),
        'address': injection,
      });

      final safeLookup = await db.query(
        'tblUser',
        where: 'address = ?',
        whereArgs: [injection],
      );
      expect(safeLookup, hasLength(1));

      final allRows = await db.query('tblUser');
      expect(allRows, hasLength(1));

      await db.close();
    });

    test('parameterized delete does not execute injected id clause', () async {
      final db = await openDatabase(
        inMemoryDatabasePath,
        version: 1,
        onCreate: (database, version) async {
          await database.execute(
            'CREATE TABLE tblPolicy (id INTEGER PRIMARY KEY, policy_no TEXT)',
          );
        },
      );

      await db.insert('tblPolicy', {'policy_no': 'P-001'});
      await db.insert('tblPolicy', {'policy_no': 'P-002'});

      final maliciousId = "1 OR 1=1";
      final deleted = await db.rawDelete(
        'DELETE FROM tblPolicy WHERE id = ?',
        [maliciousId],
      );

      expect(deleted, 0);

      final remaining = await db.query('tblPolicy');
      expect(remaining, hasLength(2));

      await db.close();
    });

    test('vulnerable string concatenation would be unsafe (reference only)', () async {
      final db = await openDatabase(
        inMemoryDatabasePath,
        version: 1,
        onCreate: (database, version) async {
          await database.execute(
            'CREATE TABLE tblUser (id INTEGER PRIMARY KEY, name TEXT)',
          );
          await database.insert('tblUser', {'name': 'legit'});
          await database.insert('tblUser', {'name': 'hacker'});
        },
      );

      const injection = "' OR '1'='1";

      final vulnerable = await db.rawQuery(
        "SELECT * FROM tblUser WHERE name = '$injection'",
      );
      expect(vulnerable.length, greaterThan(1));

      final safe = await db.rawQuery(
        'SELECT * FROM tblUser WHERE name = ?',
        [injection],
      );
      expect(safe, isEmpty);

      await db.close();
    });
  });
}
