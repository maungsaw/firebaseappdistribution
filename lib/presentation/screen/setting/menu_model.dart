import 'package:flutter/material.dart';

class MasterMenuOption {
  final String title;
  final IconData leadingIcon;
  final VoidCallback onTap;
  final Widget? trailing;

  MasterMenuOption({
    required this.title,
    required this.leadingIcon,
    required this.onTap,
    this.trailing,
  });
}
