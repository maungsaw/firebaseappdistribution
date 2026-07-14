import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart'
    show DatabaseHelper, UserModel;
import 'package:flutter/rendering.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class UserDAO {
  static final table = Schema.tblUser;

  static Future<void> createTable(Database db) async {
    await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            phone TEXT NOT NULL,
            nrc TEXT NOT NULL,
            address TEXT NOT NULL
          );
        ''');
  }

  static Future<void> seedExampleData(Database db) async {
    final countResult = await db.rawQuery('SELECT COUNT(*) FROM $table');
    final count = Sqflite.firstIntValue(countResult) ?? 0;
    if (count > 0) return;

    final examples = [
      UserModel(
        name: 'Aung Aung',
        phone: '09123456789',
        nrc: '12/YGN(N)123456',
        address: 'No. 45, Kabar Aye Pagoda Road, Bahan Township, Yangon',
      ),
      UserModel(
        name: 'Su Su',
        phone: '09987654321',
        nrc: '9/MDY(N)654321',
        address: 'No. 12, 78th Street, Chan Aye Thar Zan Township, Mandalay',
      ),
      UserModel(
        name: 'Kyaw Kyaw',
        phone: '09234567890',
        nrc: '3/BGE(N)789012',
        address: 'No. 8, Main Road, Bago Township, Bago Region',
      ),
    ];

    for (final user in examples) {
      await db.insert(table, user.toEncryptedMap());
    }
  }

  Future<List<UserModel>> getAllDecrypted() async {
    try {
      final db = await database;
      final result = await db.rawQuery('SELECT * FROM $table');
      if (result.isEmpty) return [];
      return result.map((row) => UserModel.fromEncryptedMap(row)).toList();
    } on Exception catch (_, e) {
      debugPrint('User ORM ERROR -> $e');
      return [];
    }
  }

  Future<Database> get database => DatabaseHelper().database;
}
