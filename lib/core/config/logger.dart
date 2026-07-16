import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../core.dart';

class LoggerConfig {
  // --- Bloc Logging Settings ---
  static TalkerBlocLoggerSettings get blocLoggerSettings =>
      const TalkerBlocLoggerSettings(
        printChanges: true,
        printClosings: true,
        printCreations: false,
        printEvents: true,
        printTransitions: true,
      );

  static Talker get talker => AppTalker.instance;

  // --- Initialize Bloc Observer ---
  static void initBlocObserver() {
    Bloc.observer = TalkerBlocObserver(
      talker: talker,
      settings: blocLoggerSettings,
    );
  }

  // --- Error Labels & Handling ---
  static const String flutterErrorLabel = 'FlutterError';
  static const String platformDispatcherLabel = 'PlatformDispatcher';
  static const String zoneErrorLabel = 'Uncaught zone error';

  static void setupErrorHandling() {
    FlutterError.onError = (details) {
      talker.handle(details.exception, details.stack, flutterErrorLabel);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      talker.handle(error, stack, platformDispatcherLabel);
      return true;
    };
  }

  static String get appTitle => 'My Flutter App';
}
