import 'package:flutter/material.dart';

abstract class AppRoutes {
  static const String home = '/';
  static const String calculator = '/calculator';
  static const String policy = '/policy';
}

abstract class RootNavigation {
  static final GlobalKey<NavigatorState> rootKey = GlobalKey<NavigatorState>();
  static final navigationIcons = [
    Icons.home_max,
    Icons.integration_instructions_sharp,
    Icons.person,
  ];
}
