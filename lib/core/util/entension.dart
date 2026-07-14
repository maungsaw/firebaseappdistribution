import 'const.dart';
import 'enum.dart';

extension RouteNameExtension on RouteName {
  String get path {
    switch (this) {
      case RouteName.home:
        return AppRoutes.home;
      case RouteName.calculator:
        return AppRoutes.calculator;
      case RouteName.policy:
        return AppRoutes.policy;
      case RouteName.premiumTerm:
        return AppRoutes.premiumTerm;
      case RouteName.premiumPolicy:
        return AppRoutes.premiumPolicy;
      case RouteName.taskManage:
        return AppRoutes.taskManage;
      case RouteName.tax:
        return AppRoutes.tax;
      case RouteName.user:
        return AppRoutes.user;
      case RouteName.profile:
        return AppRoutes.profile;
      case RouteName.login:
        return AppRoutes.login;
    }
  }
}
