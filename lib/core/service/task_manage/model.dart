import 'package:flutter/widgets.dart';

enum JiraStatus { toDo, inProgress, done }

enum CalendarViewMode { month, week, day }

class JiraTimeTask {
  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  final JiraStatus status;
  final String? remark;

  JiraTimeTask({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.status,
    this.remark,
  });
}

class CustomHoliday {
  final DateTime date;
  final String name;

  CustomHoliday({required this.date, required this.name});
}
