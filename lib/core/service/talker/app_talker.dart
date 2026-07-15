import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Central Talker instance for app logs, Dio, and BLoC.
abstract final class AppTalker {
  static Talker? _instance;

  static Talker get instance {
    final existing = _instance;
    if (existing != null) return existing;
    return _instance = TalkerFlutter.init(
      settings: TalkerSettings(
        enabled: true,
        useConsoleLogs: kDebugMode,
        maxHistoryItems: 1000,
      ),
    );
  }

  static void info(String message, [Object? exception, StackTrace? stack]) {
    instance.info(message);
    if (exception != null) {
      instance.handle(exception, stack, message);
    }
  }

  static void warning(String message) => instance.warning(message);

  static void error(
    String message, [
    Object? exception,
    StackTrace? stackTrace,
  ]) {
    if (exception != null) {
      instance.handle(exception, stackTrace, message);
    } else {
      instance.error(message);
    }
  }

  static void debug(String message) => instance.debug(message);
}
