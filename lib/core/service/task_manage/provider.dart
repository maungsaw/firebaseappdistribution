import 'package:flutter/material.dart';

import 'model.dart';

class JiraTimeCalendarProvider extends ChangeNotifier {
  DateTime _focusedDate = DateTime.now();
  CalendarViewMode _viewMode = CalendarViewMode.day;
  List<JiraTimeTask> _tasks = [];
  final Map<String, CustomHoliday> _holidays = {};

  DateTime get focusedDate => _focusedDate;
  CalendarViewMode get viewMode => _viewMode;
  List<JiraTimeTask> get tasks => _tasks;
  Map<String, CustomHoliday> get holidays => _holidays;
  // Initialize to current date (Today)
  DateTime? _activeDate = DateTime.now();

  DateTime? get activeDate => _activeDate;

  // Helper to strip the time part for clean date comparison
  DateTime normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  void setActiveDate(DateTime? date) {
    _activeDate = date;
    notifyListeners();
  }

  DateTime stripTime(DateTime d) => DateTime(d.year, d.month, d.day);

  void setViewMode(CalendarViewMode mode) {
    _viewMode = mode;
    notifyListeners();
  }

  void next() {
    switch (_viewMode) {
      case CalendarViewMode.month:
        _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1, 1);
        _activeDate = DateTime(_focusedDate.year, _focusedDate.month, 1);
        break;
      case CalendarViewMode.week:
        _focusedDate = _focusedDate.add(const Duration(days: 7));
        if (activeDate != null) {
          _activeDate = _focusedDate.subtract(
            Duration(days: _focusedDate.weekday - 1),
          );
        }
        break;
      case CalendarViewMode.day:
        _focusedDate = _focusedDate.add(const Duration(days: 1));
        _activeDate = _focusedDate;
        break;
    }
    notifyListeners();
  }

  void previous() {
    switch (_viewMode) {
      case CalendarViewMode.month:
        _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1, 1);
        _activeDate = DateTime(_focusedDate.year, _focusedDate.month, 1);
        break;
      case CalendarViewMode.week:
        _focusedDate = _focusedDate.subtract(const Duration(days: 7));

        // 2. Set activeDate to the first day of this new week
        if (activeDate != null) {
          _activeDate = _focusedDate.subtract(
            Duration(days: _focusedDate.weekday - 1),
          );
        }
        break;
      case CalendarViewMode.day:
        _focusedDate = _focusedDate.subtract(const Duration(days: 1));
        _activeDate = _focusedDate;
        break;
    }
    notifyListeners();
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

      // Check if active date is within the range [start, end]
      return (active.isAtSameMomentAs(start) || active.isAfter(start)) &&
          (active.isAtSameMomentAs(end) || active.isBefore(end));
    }).toList();
  }
}
