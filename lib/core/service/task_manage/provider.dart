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

  void setViewMode(CalendarViewMode mode) {
    _viewMode = mode;
    notifyListeners();
  }

  void next() {
    switch (_viewMode) {
      case CalendarViewMode.month:
        _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1, 1);
        break;
      case CalendarViewMode.week:
        _focusedDate = _focusedDate.add(const Duration(days: 7));
        break;
      case CalendarViewMode.day:
        _focusedDate = _focusedDate.add(const Duration(days: 1));
        break;
    }
    notifyListeners();
  }

  void previous() {
    switch (_viewMode) {
      case CalendarViewMode.month:
        _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1, 1);
        break;
      case CalendarViewMode.week:
        _focusedDate = _focusedDate.subtract(const Duration(days: 7));
        break;
      case CalendarViewMode.day:
        _focusedDate = _focusedDate.subtract(const Duration(days: 1));
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
}
