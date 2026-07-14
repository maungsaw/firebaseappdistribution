import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart'
    show DatabaseHelper, PremiumTermModel;
import 'package:flutter/rendering.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class PremiumTermDAO {
  static final table = Schema.tblPremiumTerm;
  static Future<void> createTable(Database db) async {
    await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            label TEXT NOT NULL,
            value int NOT NULL
          );
        ''');
  }

  // Example: Getting the count of policies
  Future<int> getCount() async {
    final db = await database;
    // Use Sqflite's count helper for better performance
    final result = await db.rawQuery("SELECT COUNT(*) FROM $table");
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<PremiumTermModel>> getAll() async {
    try {
      final db = await database;
      final result = await db.rawQuery("SELECT * FROM $table");
      if (result.isEmpty) return [];
      return result.map((e) => PremiumTermModel.fromMap(e)).toList();
    } on Exception catch (_, e) {
      debugPrint("ORM ERROR -> $e");
      return [];
    }
  }

  Future<int> insert(PremiumTermModel data) async {
    final db = await database;
    final result = await db.insert(table, data.toMap());
    return result;
  }

  Future<int> update(PremiumTermModel data, int id) async {
    try {
      final db = await database;
      final result = await db.update(
        table,
        data.toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
      return result;
    } catch (e) {
      debugPrint("Update Policy ORM Error -> $e");
      return -1;
    }
  }

  Future<int> remove(int id) async {
    final db = await database;
    final result = await db.rawDelete('DELETE FROM $table WHERE id = ?', [id]);
    return result;
  }

  Future<Database> get database => DatabaseHelper().database;
}
