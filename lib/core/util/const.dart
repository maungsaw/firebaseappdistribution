import 'package:flutter/material.dart';

abstract class AppRoutes {
  static const String home = '/';
  static const String calculator = '/calculator';
  static const String policy = '/policy';
  static const String premiumTerm = '/premium-term';
  static const String premiumPolicy = '/premium-policy';
  static const String taskManage = '/task-manage';
  static const String tax = '/tax';
  static const String user = '/user';
  static const String profile = '/profile';
  static const String login = '/login';
  static const String talker = '/talker';
}

abstract class RootNavigation {
  static final GlobalKey<NavigatorState> rootKey = GlobalKey<NavigatorState>();
  static final navigationIcons = [
    Icons.home_max,
    Icons.integration_instructions_sharp,
    Icons.person,
  ];
}

abstract class Constrants {
  static final String signatureKey =
      'UC9+Aic/xe97krhij8zsU8neNKo0qNheVT6wF2VHn73648qT5zW3J8ngoLlU1u3z';
}
