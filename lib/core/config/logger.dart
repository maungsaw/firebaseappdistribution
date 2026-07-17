import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_flutter/talker_flutter.dart';

class LoggerConfig {
  static final talker = Talker(
    // Optional: Configure your logger differently based on mode
    settings: TalkerSettings(
      enabled: true,
      useConsoleLogs: kDebugMode, // Only log to console in debug
    ),
  );

  static const appTitle = "MyApp";
  static const zoneErrorLabel = "Zone Error";

  static void init() {
    // 1. Always setup standard error handling
    FlutterError.onError = (details) {
      talker.handle(details.exception, details.stack, 'Flutter Error');
    };

    // 2. Conditional Initialization
    if (kDebugMode) {
      // Only attach the Observer if we are in Debug
      Bloc.observer = TalkerBlocObserver(talker: talker);
      talker.info('Debug Mode: BlocObserver and console logging enabled');
    } else {
      // Perhaps only log critical errors to a service like Sentry/Crashlytics in release
      talker.info('Release Mode: Standard logging active');
    }
  }
}
