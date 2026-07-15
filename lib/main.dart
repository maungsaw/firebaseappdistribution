import 'package:firebaseappdistribution/firebase.dart';
import 'package:firebaseappdistribution/pushy.dart';
import 'package:firebaseappdistribution/remote_config.dart';
import 'app_dependencies.dart';
import 'package:flutter/material.dart';
import 'core/core.dart'
    show
        AppRouter,
        DeviceInfoService,
        ForegroundScheculerService,
        SystemBottomBarService;
import 'data/data.dart';
import 'injection.dart';

void main() async {
  Injection.initInjector();
  WidgetsFlutterBinding.ensureInitialized();
  await DeviceInfoService.logToDebugConsole();
  await FirebaseInjection.initFirebaseServices();
  await PushyInjection.initPushyServices();
  await FileStorageService.createFolders();
  await DatabaseFileService.ensureDatabaseFile();
  await DatabaseHelper().open();
  ForegroundScheculerService().initTask();
  SystemBottomBarService.ensureVisible();
  runApp(MyApp());
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
