import 'dart:async';

import 'package:firebaseappdistribution/firebase.dart';
import 'package:firebaseappdistribution/pushy.dart';
import 'package:flutter/foundation.dart';
import 'package:firebaseappdistribution/remote_config.dart';
import 'app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

import 'app_dependencies.dart';
import 'core/core.dart'
    show
        AppRouter,
        AppTalker,
        DeviceInfoService,
        ForegroundScheculerService,
        SystemBottomBarService;
import 'data/data.dart';
import 'injection.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      Injection.initInjector();
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (details) {
        AppTalker.instance.handle(
          details.exception,
          details.stack,
          'FlutterError',
        );
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        AppTalker.instance.handle(error, stack, 'PlatformDispatcher');
        return true;
      };

      Bloc.observer = TalkerBlocObserver(
        talker: AppTalker.instance,
        settings: const TalkerBlocLoggerSettings(
          printChanges: true,
          printClosings: true,
          printCreations: false,
          printEvents: true,
          printTransitions: true,
        ),
      );

      AppTalker.info('App starting');
      await DeviceInfoService.logToDebugConsole();
      await FirebaseInjection.initFirebaseServices();
      await PushyInjection.initPushyServices();
      await FileStorageService.createFolders();
      await DatabaseFileService.ensureDatabaseFile();
      await DatabaseHelper().open();
      ForegroundScheculerService().initTask();
      SystemBottomBarService.ensureVisible();
      runApp(const MyApp());
    },
    (error, stack) {
      AppTalker.instance.handle(error, stack, 'Uncaught zone error');
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaintenanceWrapper(
      child: AppDependencies(
        child: MaterialApp.router(
          routerConfig: AppRouter.router,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0x000950A8),
              brightness: Brightness.light,
            ),
          ),
          // Optional but highly recommended: Auto Dark Mode
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0x000950A8),
              brightness: Brightness.dark,
            ),
          ),
          themeMode: ThemeMode.system,
        ),
      ),
    );
  }
}
