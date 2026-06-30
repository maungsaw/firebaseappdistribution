import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ReorderablePremiumList extends StatelessWidget {
  final List<dynamic> items;
  final Function(int oldIndex, int newIndex) onReorder;
  final Function(dynamic item) onEdit;
  final Function(dynamic item) onDelete;

  const ReorderablePremiumList({
    super.key,
    required this.items,
    required this.onReorder,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          'No premium terms found. Tap + to add one.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final theme = Theme.of(context);

    return ReorderableListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: items.length,
      // ignore: deprecated_member_use
      onReorder: onReorder,
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];
        final itemKey = item.id ?? index.toString();

        // Wrap the item in a Slidable instead of Dismissible
        return Slidable(
          key: ValueKey('slidable_$itemKey'),

          // This defines the actions that appear when swiping Right-to-Left (iOS style)
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.3, // Width space for the two circular buttons
            children: [
              // 1. THE CIRCULAR EDIT BUTTON
              CustomSlidableAction(
                onPressed: (context) => onEdit(item),
                backgroundColor: Colors
                    .transparent, // Keeps the background clear around the circle
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle, // Forces a perfect round shape
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    color: theme.colorScheme.onPrimary,
                    size: 22,
                  ),
                ),
              ),

              // 2. THE CIRCULAR DELETE BUTTON
              CustomSlidableAction(
                onPressed: (context) => onDelete(item),
                backgroundColor: Colors.transparent,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),

          // The core main tile component that moves out of the way
          child: Card(
            key: ValueKey(
              itemKey,
            ), // Still tracked natively by ReorderableListView
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              leading: const Icon(
                Icons.access_time_rounded,
                color: Colors.grey,
              ),
              title: Text(
                item.label,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: Icon(
                Icons.chevron_left_rounded, // Classical iOS detail cue
                size: 20,
                color: Colors.grey.withValues(alpha: 0.6),
              ),
            ),
          ),
        );
      },
    );
  }
}
