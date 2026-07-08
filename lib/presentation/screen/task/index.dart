import 'package:firebaseappdistribution/core/core.dart';
import 'package:flutter/material.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  void onCreate(DateTime date) {
    debugPrint('UI VIew -> onCreate $date');
  }

  void onEdit(JiraTimeTask task) {
    debugPrint('UI View -> task ${task.title}');
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return JiraTimeCalendarView(
      tasks: [
        JiraTimeTask(
          id: 'task-agile-sync',
          title: 'Daily Standup & Flutter SOP Alignment',
          startTime: DateTime(today.year, today.month, today.day, 9, 0),
          endTime: DateTime(today.year, today.month, today.day, 10, 30),
          color: const Color.fromARGB(255, 55, 60, 201), // Indigo
          status: JiraStatus.done,
          remark: 'Align team on Riverpod state standardization',
        ),

        // Task 3: Evening High-Priority Hotfix (Today Only - Overlaps Task 1's timeline)
        JiraTimeTask(
          id: 'task-payment-hotfix',
          title: 'Hotfix: Payment Gateway Timeout Issue',
          startTime: DateTime(today.year, today.month, today.day, 16, 0),
          endTime: DateTime(today.year, today.month, today.day, 17, 0),
          color: const Color.fromARGB(255, 203, 137, 137), // Crimson Red
          status: JiraStatus.toDo,
          remark: 'Investigate API payload encryption headers',
        ),

        // Task 4: Mid-Week Cross-Team Review (Spans 3 Days into the future)
        JiraTimeTask(
          id: 'task-cross-review',
          title: 'Cross-Hub Database Migration Sync',
          startTime: DateTime(today.year, today.month, today.day + 2, 11, 0),
          endTime: DateTime(today.year, today.month, today.day + 4, 16, 30),
          color: const Color.fromARGB(255, 200, 131, 85), // Orange
          status: JiraStatus.toDo,
          remark: 'Verify staging schemas match historical records',
        ),

        // Task 5: End of Week Client Reporting Automation (Next Week / Day + 5)
        JiraTimeTask(
          id: 'task-automation-reporting',
          title: 'Build Automated Reporting Automation Scripts',
          startTime: DateTime(today.year, today.month, today.day + 5, 13, 0),
          endTime: DateTime(today.year, today.month, today.day + 5, 15, 0),
          color: const Color.fromARGB(255, 48, 122, 121), // Teal
          status: JiraStatus.inProgress,
          remark: 'Map dynamic SQL aggregates back to Looker views',
        ),
      ],
      holidays: [],
      onTapCreate: (DateTime date) => onCreate(date),
      onTapUpdate: (JiraTimeTask t) => onEdit(t),
    );
  }
}
