import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/presentation/presentation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'menu_card.dart';
import 'menu_model.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with WidgetsBindingObserver {
  final PhoneSecuritySession _session = PhoneSecuritySession.instance;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _session.addListener(_onSessionChanged);
    _session.ensureCapabilitiesLoaded();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _session.removeListener(_onSessionChanged);
    super.dispose();
  }

  void _onSessionChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _session.refreshCapabilities();
    }
  }

  Future<void> _verifyPhoneSecurity() async {
    if (_isAuthenticating) return;

    final capabilities = _session.capabilities;
    if (capabilities == null || !capabilities.canUseSecurity) {
      await showDeviceSecuritySetupDialog(context);
      return;
    }

    if (_session.isVerified) {
      GlobalSnackbar.showInfo(
        context,
        'Already verified for this session using ${capabilities.methodLabel}',
      );
      return;
    }

    setState(() => _isAuthenticating = true);

    final unlocked = await requestSecureUnlock(
      context,
      reason: 'Verify using your phone fingerprint, face, or lock screen',
    );

    if (!mounted) return;
    setState(() => _isAuthenticating = false);

    if (!unlocked && !_session.isVerified) return;
  }

  Future<void> _openUserScreen() async {
    final unlocked = await requestSecureUnlock(
      context,
      showSuccessMessage: !_session.isVerified,
    );
    if (!mounted || !unlocked) return;
    await context.push(AppRoutes.user);
  }

  void _lockSession() {
    _session.lock();
    GlobalSnackbar.showInfo(context, 'Phone security locked for this session');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final capabilities =
        _session.capabilities ?? PhoneSecurityCapabilities.loading;
    final isVerified = _session.isVerified;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        GestureDetector(
          onTap: () => context.push(AppRoutes.profile),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isVerified
                    ? Colors.green.withValues(alpha: 0.35)
                    : theme.colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: theme.colorScheme.primary,
                  child: Icon(
                    Icons.person,
                    color: theme.colorScheme.onPrimary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Agent-1',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isVerified ? 'Secured Session' : 'Active Session',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isVerified
                              ? Colors.green.shade700
                              : theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (isVerified) ...[
                        const SizedBox(height: 2),
                        Text(
                          capabilities.shortStatusLabel,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  isVerified
                      ? Icons.verified_rounded
                      : Icons.verified_user_rounded,
                  color: isVerified
                      ? Colors.green
                      : theme.colorScheme.primary.withAlpha(7),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        PhoneSecurityCard(
          capabilities: capabilities,
          isVerified: isVerified,
          isAuthenticating: _isAuthenticating || _session.isLoadingCapabilities,
          onTap: _verifyPhoneSecurity,
          onLock: isVerified ? _lockSession : null,
        ),
        const SizedBox(height: 24),
        DynamicMasterSectionCard(
          sectionTitle: 'Master',
          options: [
            MasterMenuOption(
              title: 'Premium Term',
              leadingIcon: Icons.access_time_rounded,
              onTap: () => context.push(AppRoutes.premiumTerm),
            ),
            MasterMenuOption(
              title: 'Premium Policy',
              leadingIcon: Icons.description_rounded,
              onTap: () => context.push(AppRoutes.premiumPolicy),
            ),
            MasterMenuOption(
              title: 'Tasks',
              leadingIcon: Icons.task,
              onTap: () => context.push(AppRoutes.taskManage),
            ),
            MasterMenuOption(
              title: 'Tax',
              leadingIcon: Icons.receipt_long_rounded,
              onTap: () => context.push(AppRoutes.tax),
            ),
            MasterMenuOption(
              title: 'User',
              leadingIcon: Icons.people_rounded,
              onTap: _openUserScreen,
              trailing: isVerified
                  ? Icon(
                      Icons.lock_open_rounded,
                      color: Colors.green.shade600,
                      size: 18,
                    )
                  : null,
            ),
            MasterMenuOption(
              title: 'AddOn',
              leadingIcon: Icons.assignment_add,
              onTap: () => debugPrint('Go to AddOn'),
            ),
            MasterMenuOption(
              title: 'Surrender Value',
              leadingIcon: Icons.money_off,
              onTap: () => debugPrint('Go to AddOn'),
            ),
            if (kDebugMode)
              MasterMenuOption(
                title: 'Talker logs',
                leadingIcon: Icons.bug_report_rounded,
                onTap: () => context.push(AppRoutes.talker),
              ),
          ],
        ),
      ],
    );
  }
}
