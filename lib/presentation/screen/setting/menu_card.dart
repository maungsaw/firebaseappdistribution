import 'package:flutter/material.dart';

import 'menu_model.dart';

class DynamicMasterSectionCard extends StatelessWidget {
  final String sectionTitle;
  final List<MasterMenuOption> options;

  const DynamicMasterSectionCard({
    super.key,
    required this.sectionTitle,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    // If there are no options, don't render an empty card
    if (options.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return ListView(
      shrinkWrap: true, // Allows it to be nested or sized by content
      physics: const ClampingScrollPhysics(),
      children: [
        Text(
          sectionTitle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Card.filled(
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ListTile.divideTiles(
              context: context,
              // Map your list of data into a list of ListTiles dynamically!
              tiles: options.map((option) {
                return ListTile(
                  leading: Icon(option.leadingIcon),
                  title: Text(option.title),
                  onTap: option.onTap,
                  trailing: option.trailing ??
                      const Icon(
                        Icons.arrow_forward,
                      ),
                );
              }),
            ).toList(),
          ),
        ),
      ],
    );
  }
}
