import 'package:firebaseappdistribution/core/core.dart' show Schema;
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'local.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  final _version = Schema.databaseVersion;

  bool get isOpen => _database != null;

  String get encryptionKey => Schema.databasePwd;
  Future<Database> get db async => await open();

  Future<Database> open() async {
    if (_database != null) return _database!;
    await DatabaseFileService.ensureDatabaseFile();
    final path = await DatabaseFileService.getDatabasePath();
    final password = Schema.databasePwd;

    _database = await openDatabase(
      path,
      password: password,
      version: _version,
      onCreate: (db, version) async {
        await _createSchema(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await UserDAO.createTable(db);
          await UserDAO.seedExampleData(db);
        }
        if (oldVersion < 3) {
          await db.delete(Schema.tblUser);
          await UserDAO.seedExampleData(db);
        }
      },
    );

    return _database!;
  }

  Future<Database> get database async => open();

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  static Future<void> _createSchema(Database db) async {
    await PolicyDAO.createTable(db);
    await PremiumRateDAO.createTable(db);
    await PremiumPolicyDAO.createTable(db);
    await PremiumTermDAO.createTable(db);
    await UserDAO.createTable(db);
    await UserDAO.seedExampleData(db);
  }
}
