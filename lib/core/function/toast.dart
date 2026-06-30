import 'package:flutter/material.dart';

class GlobalSnackbar {
  /// Standard informational snackbar message
  static void showInfo(BuildContext context, String message) {
    _show(
      context: context,
      message: message,
      backgroundColor: Colors.blueGrey[900]!,
      icon: Icons.info_outline,
    );
  }

  /// Error snackbar message with red accent styling
  static void showError(BuildContext context, String message) {
    _show(
      context: context,
      message: message,
      backgroundColor: Colors.redAccent[700]!,
      icon: Icons.error_outline,
      duration: const Duration(
        seconds: 4,
      ), // Give users more time to read system/crypto errors
    );
  }

  /// Success snackbar message with green styling
  static void showSuccess(BuildContext context, String message) {
    _show(
      context: context,
      message: message,
      backgroundColor: Colors.greenAccent,
      icon: Icons.check_circle_outline,
    );
  }

  /// Private helper method to handle structural setup and avoid redundancy
  static void _show({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 2, milliseconds: 500),
  }) {
    // Clear any active snackbars immediately to avoid stacking delays
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
