import 'app_dependencies.dart';
import 'package:flutter/material.dart';
import 'core/core.dart'
    show AppRouter, FileStorageService, ForegroundScheculerService;
import 'firebase.dart';
import 'injection.dart';

void main() async {
  Injection.initInjector();
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInjection.initFirebaseServices();
  await FileStorageService.createFolders();
  ForegroundScheculerService().initTask();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppDependencies(
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
    );
  }
}
