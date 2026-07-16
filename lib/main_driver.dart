import 'package:flutter_driver/driver_extension.dart';

import 'main.dart' as app;

/// MCP / flutter_driver entrypoint. Run with:
/// `flutter run -t lib/main_driver.dart -d <device>`
void main() {
  enableFlutterDriverExtension();
  app.main();
}
