import 'dart:io';

import 'package:firebaseappdistribution/core/dev/bundled_db_sql_injection_runner.dart';
import 'package:flutter/widgets.dart';

/// One-shot runner for device testing.
/// Prefer: flutter test integration_test/bundled_db_sql_injection_test.dart -d <device-id>
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final result = await runBundledDbSqlInjectionTests();
  for (final line in result.logs) {
    stdout.writeln(line);
  }

  exit(result.success ? 0 : 1);
}
