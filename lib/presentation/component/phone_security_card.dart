import 'package:firebaseappdistribution/core/core.dart';
import 'package:flutter/material.dart';

class PhoneSecurityCard extends StatelessWidget {
  const PhoneSecurityCard({
    super.key,
    required this.capabilities,
    required this.isVerified,
    required this.isAuthenticating,
    required this.onTap,
    this.onLock,
  });

  final PhoneSecurityCapabilities capabilities;
  final bool isVerified;
  final bool isAuthenticating;
  final VoidCallback? onTap;
  final VoidCallback? onLock;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canUse = capabilities.canUseSecurity;

    final Color borderColor;
    final Color containerColor;
    final IconData trailingIcon;
    final String title;
    final String subtitle;

    if (isVerified) {
      borderColor = Colors.green.withValues(alpha: 0.45);
      containerColor = Colors.green.withValues(alpha: 0.12);
      trailingIcon = Icons.verified_rounded;
      title = 'Phone Security';
      subtitle =
          'Verified this session\n${capabilities.methodLabel}';
    } else if (!canUse) {
      borderColor = theme.colorScheme.outline.withValues(alpha: 0.3);
      containerColor = theme.colorScheme.surfaceContainerHighest;
      trailingIcon = Icons.info_outline_rounded;
      title = 'Phone Security';
      subtitle =
          'Screen lock not configured on this phone\n'
          'Tap to see setup steps';
    } else {
      borderColor = theme.colorScheme.primary.withValues(alpha: 0.25);
      containerColor = theme.colorScheme.surfaceContainerHighest;
      trailingIcon = capabilities.icon;
      title = 'Phone Security';
      subtitle =
          'Tap once to verify using phone settings\n'
          '${capabilities.methodLabel}';
    }

    return Card.filled(
      color: containerColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor),
      ),
      child: ListTile(
        leading: Icon(
          isVerified ? Icons.verified_user_rounded : Icons.security_rounded,
          color: isVerified ? Colors.green : null,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isVerified ? Colors.green.shade700 : null,
          ),
        ),
        subtitle: Text(subtitle),
        isThreeLine: true,
        trailing: isAuthenticating
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isVerified && onLock != null)
                    IconButton(
                      tooltip: 'Lock again',
                      onPressed: onLock,
                      icon: const Icon(Icons.lock_outline_rounded, size: 20),
                    ),
                  Icon(
                    trailingIcon,
                    color: isVerified ? Colors.green : theme.colorScheme.primary,
                  ),
                ],
              ),
        onTap: isAuthenticating ? null : onTap,
      ),
    );
  }
}
