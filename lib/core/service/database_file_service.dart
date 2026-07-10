import 'dart:io';

import 'package:firebaseappdistribution/core/core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabaseFileService {
  static Future<String> getDatabasePath() async {
    final appDir = await getApplicationDocumentsDirectory();
    final dbDir = Directory(p.join(appDir.path, Schema.databaseFolder));
    if (!await dbDir.exists()) {
      await dbDir.create(recursive: true);
    }
    return p.join(dbDir.path, Schema.databaseName);
  }

  /// Copies the bundled SQLCipher database from assets on first launch.
  static Future<void> ensureDatabaseFile() async {
    final dbPath = await getDatabasePath();
    final dbFile = File(dbPath);
    if (await dbFile.exists()) return;

    try {
      final assetBytes = await rootBundle.load(Schema.databaseAssetPath);
      await dbFile.writeAsBytes(
        assetBytes.buffer.asUint8List(
          assetBytes.offsetInBytes,
          assetBytes.lengthInBytes,
        ),
        flush: true,
      );
      debugPrint('Database copied from assets to $dbPath');
    } catch (e) {
      debugPrint('Bundled database asset not found: $e');
    }
  }

  static Future<bool> databaseFileExists() async {
    return File(await getDatabasePath()).exists();
  }

  static Future<void> cleanDatabase() async {
    final path = await getDatabasePath();
    await deleteDatabase(path);
  }
}
