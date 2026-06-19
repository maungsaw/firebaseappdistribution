import 'package:firebaseappdistribution/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../util/util.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: RootNavigation.rootKey,
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    errorBuilder: (context, state) =>
        Scaffold(body: GlobalWidget.errorView('Page not found')),

    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        builder: (BuildContext context, GoRouterState state) {
          return HomeScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.calculator,
        name: AppRoutes.calculator,
        builder: (BuildContext context, GoRouterState state) {
          return const CalculatorScreen();
        },
        // Example of a nested sub-route if you need parameters passed
        // routes: <RouteBase>[
        //   /*
        //   GoRoute(
        //     path: AppRoutes.pdfViewer,
        //     builder: (BuildContext context, GoRouterState state) {
        //       // Extract state arguments cleanly if passed during navigation
        //       final bytes = state.extra as Uint8List;
        //       return SecurePdfViewer(decryptedBytes: bytes);
        //     },
        //   ),
        //   */
        // ],
      ),
    ],
  );
}
