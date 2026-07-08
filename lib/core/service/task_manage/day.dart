import 'package:flutter/material.dart';

import 'hour_view.dart';
import 'model.dart';
import 'provider.dart';

class JiraDayView extends StatelessWidget {
  final JiraTimeCalendarProvider provider;
  final Function(DateTime) onCreate;
  final Function(JiraTimeTask) onTaskTap;

  const JiraDayView({
    super.key,
    required this.provider,
    required this.onCreate,
    required this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .all(8.0),
      child: TaskHourView(
        onTaskTap: onTaskTap,
        onCreate: (date) => onCreate(date),
        tasks: provider.getTasksForRange(provider.getActiveTasks()),
        provider: provider,
      ),
    );
  }
}
