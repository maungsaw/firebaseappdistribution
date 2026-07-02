import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart'
    show DatabaseManager, PolicyModel;
import 'package:flutter/rendering.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

mixin class PolicyORM implements DatabaseManager {
  static final table = Schema.tblPolicy;
  static Future<void> createTable(Database db) async {
    await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            policy_no TEXT NOT NULL,
            birthday TEXT NOT NULL,
            name TEXT NOT NULL,
            age int NOT NULL,
            sum_assured DOUBLE NOT NULL,
            term INT NOT NULL,
            policy DOUBLE NOT NULL,
            premium_amount DOUBLE NOT NULL,
            status TEXT,
            gender TEXT,
            file_path TEXT
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

  Future<List<PolicyModel>> getAll() async {
    try {
      final db = await database;
      final result = await db.rawQuery("SELECT * FROM $table");
      if (result.isEmpty) return [];
      return result.map((e) => PolicyModel.fromMap(e)).toList();
    } on Exception catch (_, e) {
      debugPrint("ORM ERROR -> $e");
      return [];
    }
  }

  Future<int> insert(PolicyModel data) async {
    final db = await database;
    final result = await db.insert(table, data.toMap());
    return result;
  }

  Future<int> update(PolicyModel data, int id) async {
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

  Future<double> getPremiumRates(int age, int term, String gender) async {
    try {
      final db = await database;
      debugPrint("$age $term <- Premiums");
      final raw = await db.rawQuery(
        'SELECT premium_rate FROM ${Schema.tblPremiumRate} WHERE ? BETWEEN from_age AND to_age AND premium_term = ? AND gender = ?',
        [age, term, gender],
      );
      if (raw.isEmpty) return 0.0;
      final rateValue = raw.first['premium_rate'];

      if (rateValue is num) {
        return rateValue.toDouble();
      }
      return 0.0;
    } catch (e) {
      debugPrint('Premium Rate Error - $e');
      return 0.0;
    }
  }

  @override
  Future<Database> get database => DatabaseManager().database;
}
