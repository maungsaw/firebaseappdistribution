import 'package:flutter/material.dart';

class MasterMenuOption {
  final String title;
  final IconData leadingIcon;
  final VoidCallback onTap;

  MasterMenuOption({
    required this.title,
    required this.leadingIcon,
    required this.onTap,
  });
}
