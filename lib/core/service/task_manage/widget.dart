import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'model.dart'; // Ensure this points to your model file

class BorderBoxDecoration {
  static BoxDecoration get cellBorder => BoxDecoration(
    border: Border.all(color: Colors.grey.shade100, width: 0.5),
  );
  static BoxDecoration get columnRightBorder => BoxDecoration(
    border: Border(right: BorderSide(color: Colors.grey.shade200, width: 0.8)),
  );
}

class JiraTaskCard extends StatelessWidget {
  final JiraTimeTask task;
  final VoidCallback onTap;

  const JiraTaskCard({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          // Using withValues for modern Flutter color opacity
          color: task.color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: task.color, width: 4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize:
              MainAxisSize.min, // Prevents layout errors in tight spaces
          children: [
            Text(
              task.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: DateFormat('h:mm a').format(task.startTime)),
                  const TextSpan(text: " - "),
                  TextSpan(text: DateFormat('h:mm a').format(task.endTime)),
                ],
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
