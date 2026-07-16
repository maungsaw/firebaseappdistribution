import 'package:flutter/material.dart';

import 'core/core.dart'
    show
        AppBootstrap,
        AppRouter,
        AppTheme,
        BlocDependencies,
        MaintenanceWrapper;

void main() async {
  await AppBootstrap.run(() => const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaintenanceWrapper(
      child: BlocDependencies(
        child: MaterialApp.router(
          routerConfig: AppRouter.router,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
        ),
      ),
    );
  }
}
