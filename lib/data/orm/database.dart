import 'package:firebaseappdistribution/core/core.dart' show Schema;
import 'package:firebaseappdistribution/core/service/database_file_service.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'orm.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  factory DatabaseManager() => _instance;
  DatabaseManager._internal();

  static Database? _database;
  final _version = Schema.databaseVersion;

  bool get isOpen => _database != null;
  String get encryptionKey => Schema.databasePwd;

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
        await _createSchema(db, password);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await UserORM.createTable(db);
          await UserORM.seedExampleData(db, password);
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

  static Future<void> _createSchema(Database db, String password) async {
    await PolicyORM.createTable(db);
    await PremiumRateORM.createTable(db);
    await PremiumPolicyORM.createTable(db);
    await PremiumTermORM.createTable(db);
    await UserORM.createTable(db);
    await UserORM.seedExampleData(db, password);
  }
}
