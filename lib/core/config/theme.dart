import 'package:flutter/material.dart';

extension AppTheme on ThemeData {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0x000950A8),
      brightness: Brightness.light,
    ),
  );
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0x000950A8),
      brightness: Brightness.dark,
    ),
  );
}
