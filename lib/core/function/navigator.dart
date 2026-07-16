import 'package:flutter/services.dart';

extension SystemNavigator on SystemChrome {
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
