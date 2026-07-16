import 'dart:async';
import 'package:flutter/material.dart';
import '../core.dart';
import '../../data/data.dart';
import 'pushy.dart';

class AppBootstrap {
  static Future<void> run(FutureOr<Widget> Function() builder) async {
    LoggerConfig.setupErrorHandling();

    await runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        Injection.initInjector();
        await _initServices();
        LoggerConfig.initBlocObserver();
        LoggerConfig.talker.info('${LoggerConfig.appTitle} starting');
        SystemBottomBarService.ensureVisible();

        runApp(await builder());
      },
      (error, stack) =>
          LoggerConfig.talker.handle(error, stack, LoggerConfig.zoneErrorLabel),
    );
  }

  static Future<void> _initServices() async {
    await DeviceInfoService.logToDebugConsole();
    await FirebaseInjection.initFirebaseServices();
    await PushyInjection.initPushyServices();
    await FileStorageService.createFolders();
    await DatabaseFileService.ensureDatabaseFile();
    await DatabaseHelper().open();
    ForegroundScheculerService().initTask();
  }
}
