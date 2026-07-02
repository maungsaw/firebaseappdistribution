import 'package:firebaseappdistribution/core/core.dart' show Schema;
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart';
import 'orm.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  factory DatabaseManager() => _instance;
  DatabaseManager._internal();
  static Database? _database;

  final _dbName = Schema.databaseName;
  final _dbPassword = Schema.databasePwd;
  final _version = Schema.databaseVersion;

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
      version:
          _version, // Incremented to 2 to trigger onUpgrade for your expiry_date
      onCreate: (db, version) async {
        await PolicyORM.createTable(db);
        await PremiumRateORM.createTable(db);
        await PremiumPolicyORM.createTable(db);
        await PremiumTermORM.createTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {},
    );
  }
}
