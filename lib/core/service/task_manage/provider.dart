import 'package:flutter/material.dart';
import 'model.dart';

class JiraTimeCalendarProvider extends ChangeNotifier {
  DateTime _focusedDate = DateTime.now();
  CalendarViewMode _viewMode = CalendarViewMode.month;
  List<JiraTimeTask> _tasks = [];
  final Map<String, CustomHoliday> _holidays = {};
  DateTime? _activeDate = DateTime.now();
  int _startHour = 9;
  int _endHour = 17;

  final double pixelsPerHour = 60.0;
  DateTime get focusedDate => _focusedDate;
  int get startHour => _startHour;
  int get endHour => _endHour;
  CalendarViewMode get viewMode => _viewMode;
  List<JiraTimeTask> get tasks => _tasks;
  Map<String, CustomHoliday> get holidays => _holidays;

  DateTime? get activeDate => _activeDate;

  DateTime normalize(DateTime d) => DateTime(d.year, d.month, d.day);
  DateTime stripTime(DateTime d) => DateTime(d.year, d.month, d.day);
  final weekdayNames = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  void setActiveDate(DateTime? date) {
    _activeDate = date;
    notifyListeners();
  }

  void setHours(int start, int end) {
    _startHour = start;
    _endHour = end;
    notifyListeners();
  }

  void setViewMode(CalendarViewMode mode) {
    _viewMode = mode;
    notifyListeners();
  }

  double calculateTopOffset(DateTime startTime) {
    int hourDifference = startTime.hour - startHour;
    double hourPixels = hourDifference * pixelsPerHour;
    double minutePixels = startTime.minute * (pixelsPerHour / 60.0);
    return hourPixels + minutePixels;
  }

  // Pass in your active date (e.g., July 9) and your view bounds (e.g., 9 to 18 for 9 AM to 6 PM)
  double calculateTaskHeight(DateTime startTime, DateTime endTime) {
    int totalDurationInMinutes = endTime.difference(startTime).inMinutes;
    return totalDurationInMinutes * (pixelsPerHour / 60.0);
  }

  void updateTasks(List<JiraTimeTask> newTasks) {
    _tasks = newTasks;
    notifyListeners();
  }

  void addHolidays(List<CustomHoliday> holidayList) {
    for (var holiday in holidayList) {
      _holidays[_getDateKey(holiday.date)] = holiday;
    }
    notifyListeners();
  }

  bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  CustomHoliday? getHoliday(DateTime date) {
    return _holidays[_getDateKey(date)];
  }

  String _getDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  List<JiraTimeTask> getActiveTasks() {
    if (activeDate == null) return [];

    final active = stripTime(activeDate!);

    return tasks.where((e) {
      final start = stripTime(e.startTime);
      final end = stripTime(e.endTime);
      return (active.isAtSameMomentAs(start) || active.isAfter(start)) &&
          (active.isAtSameMomentAs(end) || active.isBefore(end));
    }).toList();
  }

  List<DateTime> generateMonthDays() {
    final first = DateTime(focusedDate.year, focusedDate.month, 1);
    final last = DateTime(focusedDate.year, focusedDate.month + 1, 0);
    int offset = first.weekday - 1;
    if (offset < 0) offset = 6;

    final List<DateTime> days = [];
    final startOffsetDate = first.subtract(Duration(days: offset));
    for (int i = 0; i < offset; i++) {
      days.add(startOffsetDate.add(Duration(days: i)));
    }
    for (int i = 0; i < last.day; i++) {
      days.add(first.add(Duration(days: i)));
    }
    while (days.length % 7 != 0) {
      days.add(days.last.add(const Duration(days: 1)));
    }
    return days;
  }

  List<DateTime> getWeekDays() {
    final DateTime startOfWeek = focusedDate.subtract(
      Duration(days: focusedDate.weekday - 1),
    );
    return List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }

  /// Retrieves all tasks for a specific given day
  List<JiraTimeTask> getTasksForDay(DateTime date) {
    final targetDate = stripTime(date);

    return _tasks.where((task) {
      final start = stripTime(task.startTime);
      final end = stripTime(task.endTime);

      // Checks if the target date falls within the task range (inclusive)
      return (targetDate.isAtSameMomentAs(start) ||
              targetDate.isAfter(start)) &&
          (targetDate.isAtSameMomentAs(end) || targetDate.isBefore(end));
    }).toList();
  }

  List<JiraTimeTask> getTasksForRange(List<JiraTimeTask> focusTask) {
    final DateTime activeNormalized = stripTime(activeDate ?? DateTime.now());
    final DateTime viewStart = activeNormalized.add(Duration(hours: startHour));
    final DateTime viewEnd = activeNormalized.add(Duration(hours: endHour));

    final lastTask = focusTask.where((tk) {
      final bool overlaps =
          tk.startTime.isBefore(viewEnd) && tk.endTime.isAfter(viewStart);

      return overlaps;
    }).toList();
    return lastTask;
  }

  void updateDateFromPageIndex(int offset) {
    switch (viewMode) {
      case CalendarViewMode.day:
        _focusedDate = DateTime.now().add(Duration(days: offset));
        _activeDate = _focusedDate;
        break;
      case CalendarViewMode.week:
        _focusedDate = DateTime.now().add(Duration(days: offset * 7));
        _activeDate = _focusedDate.subtract(
          Duration(days: _focusedDate.weekday - 1),
        );
        break;
      case CalendarViewMode.month:
        _focusedDate = DateTime(
          DateTime.now().year,
          DateTime.now().month + offset,
        );
        _activeDate = DateTime(_focusedDate.year, _focusedDate.month, 1);
        break;
    }
    notifyListeners();
  }

  String getAppBarTitle() {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    if (viewMode == CalendarViewMode.day) {
      return "${activeDate!.day} ${months[activeDate!.month - 1]} ${activeDate!.year}";
    }
    return "${months[activeDate!.month - 1]} ${activeDate!.year}";
  }
}
