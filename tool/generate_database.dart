import 'dart:io';

import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/orm/orm.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

/// Generates the bundled SQLCipher database asset.
///
/// On a connected device:
///   flutter run -t tool/generate_database.dart -d [device-id]
///   adb pull /data/user/0/com.sawhtunaung.firebaseappdistribution/app_flutter/secure_insurance_v3.db assets/database/secure_insurance_v3.db
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final outputPath = await _resolveOutputPath();
  final outputFile = File(outputPath);
  if (await outputFile.exists()) {
    await outputFile.delete();
  }

  final password = Schema.databasePwd;
  final db = await openDatabase(
    outputPath,
    password: password,
    version: Schema.databaseVersion,
    onCreate: (database, version) async {
      await PolicyORM.createTable(database);
      await PremiumRateORM.createTable(database);
      await PremiumPolicyORM.createTable(database);
      await PremiumTermORM.createTable(database);
      await UserORM.createTable(database);
      await UserORM.seedExampleData(database, password);
    },
  );

  await db.close();
  stdout.writeln('Generated bundled database at $outputPath');
  stdout.writeln();
  stdout.writeln('Pull into project assets with:');
  stdout.writeln(
    'adb shell run-as com.sawhtunaung.firebaseappdistribution cp app_flutter/${Schema.databaseName} /sdcard/Download/${Schema.databaseName}',
  );
  stdout.writeln(
    'adb pull /sdcard/Download/${Schema.databaseName} assets/database/${Schema.databaseName}',
  );
  exit(0);
}

Future<String> _resolveOutputPath() async {
  final projectRoot = _findProjectRoot();
  if (projectRoot != null) {
    final outputDir = Directory(p.join(projectRoot, 'assets', 'database'));
    await outputDir.create(recursive: true);
    return p.join(outputDir.path, Schema.databaseName);
  }

  final appDir = await getApplicationDocumentsDirectory();
  return p.join(appDir.path, Schema.databaseName);
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
