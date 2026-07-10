import 'package:firebaseappdistribution/core/core.dart';
import 'package:flutter/material.dart';

/// Requests access using the phone's existing screen lock.
/// Verifies only once per app session after the first success.
Future<bool> requestSecureUnlock(
  BuildContext context, {
  String reason = 'Use your phone security to access secure user data',
  bool showSuccessMessage = true,
}) async {
  final session = PhoneSecuritySession.instance;

  if (session.isVerified) {
    return true;
  }

  if (!await DeviceAuthService.canUsePhoneSecurity()) {
    if (context.mounted) {
      await showDeviceSecuritySetupDialog(context);
    }
    return false;
  }

  final result = await DeviceAuthService.authenticate(reason: reason);
  if (!context.mounted) return false;

  if (result.success) {
    session.markVerified();
    if (showSuccessMessage) {
      GlobalSnackbar.showSuccess(context, result.userMessage);
    }
    return true;
  }

  GlobalSnackbar.showError(context, result.userMessage);
  return false;
}

Future<void> showDeviceSecuritySetupDialog(BuildContext context) async {
  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Phone Security Required'),
        content: const Text(
          'This app uses your phone security settings only.\n\n'
          'Please enable in Phone Settings:\n'
          '• Screen lock (PIN / Password / Pattern)\n'
          '• Fingerprint\n'
          '• Face unlock\n\n'
          'After setup, return to this app and verify once.\n'
          'Protected screens stay open for this session.\n\n'
          'No new password is created inside this app.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
