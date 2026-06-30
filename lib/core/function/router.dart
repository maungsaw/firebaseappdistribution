import 'package:firebaseappdistribution/data/data.dart';
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
        path: AppRoutes.premiumPolicy,
        name: AppRoutes.premiumPolicy,
        builder: (BuildContext context, GoRouterState state) {
          return PremiumPolicyScreen();
        },
        routes: [
          GoRoute(
            path: 'detail',
            builder: (BuildContext context, GoRouterState state) {
              return PremiumPolicyDetailScreen(
                data: state.extra as PremiumPolicyModel,
              );
            },
          ),
          GoRoute(
            path: 'edit',
            builder: (BuildContext context, GoRouterState state) {
              return EditPremiumPolicyScreen(
                data: state.extra as PremiumPolicyModel,
              );
            },
          ),
          GoRoute(
            path: 'create',
            builder: (BuildContext context, GoRouterState state) {
              return CreatePremiumPolicyScreen();
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.premiumTerm,
        name: AppRoutes.premiumTerm,
        builder: (BuildContext context, GoRouterState state) {
          return PremiumTermScreen();
        },
        routes: [
          GoRoute(
            path: 'detail',
            builder: (BuildContext context, GoRouterState state) {
              return PremiumTermDetailScreen(
                data: state.extra as PremiumTermModel,
              );
            },
          ),
          GoRoute(
            path: 'edit',
            builder: (BuildContext context, GoRouterState state) {
              return EditPremiumTermScreen(
                data: state.extra as PremiumTermModel,
              );
            },
          ),
          GoRoute(
            path: 'create',
            builder: (BuildContext context, GoRouterState state) {
              return CreatePremiumTermScreen();
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.policy,
        name: AppRoutes.policy,
        builder: (BuildContext context, GoRouterState state) {
          return PolicyScreen();
        },
        routes: [
          GoRoute(
            path: 'detail',
            builder: (BuildContext context, GoRouterState state) {
              return PolicyDetailScreen(policy: state.extra as PolicyModel);
            },
          ),
          GoRoute(
            path: 'edit',
            builder: (BuildContext context, GoRouterState state) {
              return EditPolicyScreen(policy: state.extra as PolicyModel);
            },
          ),
          GoRoute(
            path: 'create',
            builder: (BuildContext context, GoRouterState state) {
              return CreatePolicyScreen();
            },
          ),
        ],
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
