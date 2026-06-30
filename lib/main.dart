import 'injection.dart';
import 'package:flutter/material.dart';
import 'core/core.dart'
    show AppRouter, FileStorageService, ForegroundScheculerService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
        ),
        // Optional but highly recommended: Auto Dark Mode
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
      ),
    );
  }
}
