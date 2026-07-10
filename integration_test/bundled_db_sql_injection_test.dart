import 'package:firebaseappdistribution/core/dev/bundled_db_sql_injection_runner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('bundled secure_insurance_v3.db resists SQL injection', (
    tester,
  ) async {
    final result = await runBundledDbSqlInjectionTests();

    for (final line in result.logs) {
      // ignore: avoid_print
      print(line);
    }

    expect(
      result.success,
      isTrue,
      reason: 'SQL injection checks failed: ${result.failed} failure(s)',
    );
  });
}
