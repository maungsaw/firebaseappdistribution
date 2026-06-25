import 'injection.dart';
import 'package:flutter/material.dart';
import 'core/core.dart' show AppRouter, FileStorageService;
import 'package:worker_manager/worker_manager.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    debugPrint("Task running: $task");
    switch (task) {
      case "syncData":
        // Call your backend/database logic here
        debugPrint("Background sync started!");
        break;
    }
    return Future.value(true); // Return true to show it finished successfully
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FileStorageService.createFolders();
  await workerManager.init();
  await Workmanager().initialize(
    callbackDispatcher, // Set to false in production
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppDependencies(
      child: MaterialApp.router(routerConfig: AppRouter.router),
    );
  }
}
