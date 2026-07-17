import 'dart:async';
import 'package:flutter/material.dart';
import '../core.dart';

class AppBootstrap {
  static Future<void> run(FutureOr<Widget> Function() builder) async {
    LoggerConfig.init();
    await runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();

        Injection.initInjector();
        await DeviceInfoService.isHuaweiDevice()
            ? await PushyInjection.initPushyServices()
            : await FirebaseInjection.initFirebaseServices();
        SystemBottomBarService.ensureVisible();
        runApp(await builder());
      },
      (error, stack) =>
          LoggerConfig.talker.handle(error, stack, LoggerConfig.zoneErrorLabel),
    );
  }
}
