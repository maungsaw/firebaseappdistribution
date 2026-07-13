import 'dart:io' show Platform;

import 'package:flutter/services.dart';

/// Hides and restores the Android system navigation bar.
///
/// Flutter's `SystemNavigator` does not expose `hideBottom()`, so this service
/// uses `SystemChrome` for the same immersive behavior.
class SystemBottomBarService {
  SystemBottomBarService._();

  static void ensureVisible() => showBottom();

  static void hideBottom() {
    if (!Platform.isAndroid) return;

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: const [SystemUiOverlay.top],
    );
  }

  static void showBottom() {
    if (!Platform.isAndroid) return;

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }
}
