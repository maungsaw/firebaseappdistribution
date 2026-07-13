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
    final palette = _resolvePalette(theme, capabilities.canUseSecurity);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isAuthenticating ? null : onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: palette.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatusIcon(
                    icon: palette.leadingIcon,
                    backgroundColor: palette.iconBackground,
                    iconColor: palette.iconColor,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phone Security',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _StatusChip(
                          label: palette.statusLabel,
                          backgroundColor: palette.chipBackground,
                          foregroundColor: palette.chipForeground,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (isAuthenticating)
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else if (isVerified && onLock != null)
                    IconButton(
                      tooltip: 'Lock again',
                      onPressed: onLock,
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        Icons.lock_outline_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    )
                  else if (palette.actionLabel == null)
                    Icon(
                      palette.trailingIcon,
                      color: palette.iconColor,
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                palette.message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              if (palette.actionLabel != null) ...[
                const SizedBox(height: 12),
                _ActionLink(
                  label: palette.actionLabel!,
                  color: palette.actionColor,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  _PhoneSecurityPalette _resolvePalette(
    ThemeData theme,
    bool canUseSecurity,
  ) {
    if (isVerified) {
      return _PhoneSecurityPalette(
        borderColor: Colors.green.withValues(alpha: 0.35),
        iconBackground: Colors.green.withValues(alpha: 0.16),
        iconColor: Colors.green.shade700,
        leadingIcon: Icons.verified_user_rounded,
        trailingIcon: Icons.verified_rounded,
        statusLabel: 'Verified',
        chipBackground: Colors.green.withValues(alpha: 0.14),
        chipForeground: Colors.green.shade700,
        message:
            'This session is protected with ${capabilities.methodLabel}.',
        actionLabel: null,
        actionColor: Colors.green.shade700,
      );
    }

    if (!canUseSecurity) {
      return _PhoneSecurityPalette(
        borderColor: Colors.amber.withValues(alpha: 0.45),
        iconBackground: Colors.amber.withValues(alpha: 0.16),
        iconColor: Colors.amber.shade800,
        leadingIcon: Icons.phonelink_lock_rounded,
        trailingIcon: Icons.arrow_forward,
        statusLabel: 'Setup required',
        chipBackground: Colors.amber.withValues(alpha: 0.14),
        chipForeground: Colors.amber.shade900,
        message:
            'This phone does not have a screen lock yet. '
            'Set up PIN, password, fingerprint, or face unlock first.',
        actionLabel: 'View setup steps',
        actionColor: Colors.amber.shade800,
      );
    }

    return _PhoneSecurityPalette(
      borderColor: theme.colorScheme.primary.withValues(alpha: 0.25),
      iconBackground: theme.colorScheme.primary.withValues(alpha: 0.14),
      iconColor: theme.colorScheme.primary,
      leadingIcon: capabilities.icon,
      trailingIcon: Icons.arrow_forward,
      statusLabel: 'Tap to verify',
      chipBackground: theme.colorScheme.primary.withValues(alpha: 0.12),
      chipForeground: theme.colorScheme.primary,
      message:
          'Verify once using your phone security settings '
          '(${capabilities.methodLabel}).',
      actionLabel: 'Verify now',
      actionColor: theme.colorScheme.primary,
    );
  }
}

class _PhoneSecurityPalette {
  const _PhoneSecurityPalette({
    required this.borderColor,
    required this.iconBackground,
    required this.iconColor,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.statusLabel,
    required this.chipBackground,
    required this.chipForeground,
    required this.message,
    required this.actionLabel,
    required this.actionColor,
  });

  final Color borderColor;
  final Color iconBackground;
  final Color iconColor;
  final IconData leadingIcon;
  final IconData trailingIcon;
  final String statusLabel;
  final Color chipBackground;
  final Color chipForeground;
  final String message;
  final String? actionLabel;
  final Color actionColor;
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: iconColor, size: 24),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foregroundColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ActionLink extends StatelessWidget {
  const _ActionLink({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.arrow_forward,
            size: 18,
            color: color,
          ),
        ],
      ),
    );
  }
}
