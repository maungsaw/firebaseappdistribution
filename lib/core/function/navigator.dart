import 'package:flutter/services.dart';

abstract class SystemNavigator {
  static void hideBottom() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top], // Only show the status bar
    );
  }

  static void show() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}
