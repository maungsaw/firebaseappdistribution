import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart'
    show DatabaseHelper, PremiumRateModel;
import 'package:flutter/rendering.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

abstract class PremiumRateDAO {
  static final table = Schema.tblPremiumRate;
  static Future<void> createTable(Database db) async {
    await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            from_age int NOT NULL,
            to_age int NOT NULL,
            gender TEXT NOT NULL,
            premium_term int NOT NULL,
            premium_rate double NOT NULL
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

  Future<List<PremiumRateModel>> getAll() async {
    try {
      final db = await database;
      final result = await db.rawQuery("SELECT * FROM $table");
      if (result.isEmpty) return [];
      return result.map((e) => PremiumRateModel.fromMap(e)).toList();
    } on Exception catch (_, e) {
      debugPrint("ORM ERROR -> $e");
      return [];
    }
  }

  Future<int> insert(PremiumRateModel data) async {
    final db = await database;
    final result = await db.insert(table, data.toMap());
    return result;
  }

  Future<int> insertAll(List<PremiumRateModel> data) async {
    try {
      final db = await database;
      if (data.isEmpty) return 0;
      final batch = db.batch();
      for (final item in data) {
        batch.insert(table, item.toORM());
      }
      final results = await batch.commit(noResult: false);
      return results.length;
    } catch (e) {
      debugPrint("ORM ERROR -> $e");
      return -1;
    }
  }

  Future<int> update(PremiumRateModel data, int id) async {
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

  Future<PremiumRateModel?> get(int id) async {
    try {
      final db = await database;
      final result = await db.query(table, where: 'id = ?', whereArgs: [id]);
      return result.isEmpty ? null : PremiumRateModel.fromORM(result.first);
    } catch (e) {
      debugPrint("Update Policy ORM Error -> $e");
      return null;
    }
  }

  Future<int> remove(int id) async {
    final db = await database;
    final result = await db.rawDelete('DELETE FROM $table WHERE id = ?', [id]);
    return result;
  }

  Future<Database> get database => DatabaseHelper().database;
}
