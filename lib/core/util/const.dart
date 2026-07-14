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
}

abstract class RootNavigation {
  static final GlobalKey<NavigatorState> rootKey = GlobalKey<NavigatorState>();
  static final navigationIcons = [
    Icons.home_max,
    Icons.integration_instructions_sharp,
    Icons.person,
  ];
}
