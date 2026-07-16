import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/core/config/injection.dart';
import 'package:firebaseappdistribution/presentation/presentation.dart';
import 'package:firebaseappdistribution/presentation/screen/tax/tax.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../service/talker/app_talker.dart';
import '../util/util.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: RootNavigation.rootKey,
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: kDebugMode,
    observers: [TalkerRouteObserver(AppTalker.instance)],
    refreshListenable: Injection.sl<AuthBloc>(),
    redirect: (context, state) async {
      final bloc = Injection.sl<AuthBloc>();
      final isGoingToLogin = state.matchedLocation == AppRoutes.login;

      // 1. Await the token check to determine actual authentication status
      final token = await LocalCacheService.read('access_token');
      final bool hasToken = token != null && token.isNotEmpty;

      // 2. Check Bloc state as a secondary source of truth
      final bool isLoggedIn = bloc.state is AuthLoginSuccessState;

      // 3. Determine if the user is effectively authenticated
      final isAuthenticated = hasToken || isLoggedIn;

      // 4. Redirect Logic
      if (!isAuthenticated && !isGoingToLogin) {
        return AppRoutes.login;
      }

      if (isAuthenticated && isGoingToLogin) {
        return AppRoutes.home;
      }

      return null;
    },
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
          return CalculatorScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.taskManage,
        name: AppRoutes.taskManage,
        builder: (BuildContext context, GoRouterState state) {
          return TaskScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.tax,
        name: AppRoutes.tax,
        builder: (BuildContext context, GoRouterState state) {
          return TaxScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: AppRoutes.profile,
        builder: (BuildContext context, GoRouterState state) {
          return ProfileScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.user,
        name: AppRoutes.user,
        builder: (BuildContext context, GoRouterState state) {
          return const UserScreen();
        },
        routes: [
          GoRoute(
            path: 'detail',
            builder: (BuildContext context, GoRouterState state) {
              return UserDetailScreen(data: state.extra as UserModel);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.login,
        builder: (BuildContext context, GoRouterState state) {
          return LoginScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.talker,
        name: AppRoutes.talker,
        builder: (BuildContext context, GoRouterState state) {
          return TalkerScreen(talker: AppTalker.instance);
        },
      ),
    ],
  );
}
