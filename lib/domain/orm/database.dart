import 'package:flutter/foundation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
  // 1. Private constructor for Singleton
  DatabaseManager._privateConstructor();
  static final DatabaseManager instance = DatabaseManager._privateConstructor();

  static Database? _database;

  static const _dbName = "secure_insurance_v3.db";
  static const _dbPassword = "123456790"; // In production, store this securely!

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      password: _dbPassword,
      version: 2, // Incremented to 2 to trigger onUpgrade for your expiry_date
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE policies (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            policy_no TEXT NOT NULL,
            status TEXT,
            expiry_date TEXT
          );
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE policies ADD COLUMN expiry_date TEXT;');
        }
      },
    );
  }

  // Example: Getting the count of policies
  Future<int> getPolicyCount() async {
    final db = await database;
    // Use Sqflite's count helper for better performance
    final result = await db.rawQuery("SELECT COUNT(*) FROM policies");
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
