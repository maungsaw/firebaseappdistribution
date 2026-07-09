import 'package:firebaseappdistribution/core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'menu_card.dart';
import 'menu_model.dart';
class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28, // Correctly proportioned avatar sizing
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
                        'Active Session',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.verified_user_rounded,
                  color: theme.colorScheme.primary.withAlpha(7),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- DYNAMIC MENU SECTION ---
          DynamicMasterSectionCard(
            sectionTitle: 'Master',
            options: [
              MasterMenuOption(
                title: 'Premium Term',
                leadingIcon: Icons
                    .access_time_rounded, // Rounded icons match modern styling better
                onTap: () => context.push(RouteName.premiumTerm.path),
              ),
              MasterMenuOption(
                title: 'Premium Policy',
                leadingIcon: Icons.description_rounded,
                onTap: () => context.push(RouteName.premiumPolicy.path),
              ),
              MasterMenuOption(
                title: 'Tasks',
                leadingIcon: Icons.task,
                onTap: () => context.push(RouteName.taskManage.path),
              ),
              MasterMenuOption(
                title: 'Tax',
                leadingIcon: Icons.receipt_long_rounded,
                onTap: () => context.push(RouteName.tax.path),
              ),
              MasterMenuOption(
                title: 'User',
                leadingIcon: Icons.people_rounded,
                onTap: () => context.push(RouteName.user.path),
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
            ],
          ),
        ],
      ),
    );
  }
}
