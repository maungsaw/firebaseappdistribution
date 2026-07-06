import 'package:flutter/material.dart';

import 'day.dart';
import 'model.dart';
import 'month.dart';
import 'provider.dart';
import 'week.dart';

class JiraTimeCalendarView extends StatefulWidget {
  const JiraTimeCalendarView({super.key});

  @override
  State<JiraTimeCalendarView> createState() => _JiraTimeCalendarViewState();
}

class _JiraTimeCalendarViewState extends State<JiraTimeCalendarView> {
  late JiraTimeCalendarProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = JiraTimeCalendarProvider();

    final today = DateTime.now();

    _provider.addHolidays([
      CustomHoliday(
        date: DateTime(today.year, today.month, today.day + 2),
        name: "Public Holiday",
      ),
    ]);

    _provider.updateTasks([
      // Task 1: Existing Multi-day Task (Spans 2 Days)
      JiraTimeTask(
        id: 'task-erp-refactor',
        title: 'Enterprise ERP Architecture Refactor',
        startTime: DateTime(today.year, today.month, today.day, 10, 0),
        endTime: DateTime(today.year, today.month, today.day + 1, 15, 0),
        color: const Color.fromARGB(255, 5, 26, 58), // Jira Blue
        status: JiraStatus.inProgress,
        remark: 'Updating state layers across enterprise modules',
      ),

      // Task 2: Morning Agile Sync & Code Review (Today Only)
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
        endTime: DateTime(today.year, today.month, today.day, 18, 45),
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
    ]);
  }

  void _handleOnCreate(DateTime targetDate) {
    final holiday = _provider.getHoliday(targetDate);
    final isWeekend = _provider.isWeekend(targetDate);

    if (holiday != null || isWeekend) {
      String alertMessage = isWeekend
          ? "Weekend (Non-working Day)"
          : "${holiday!.name} (Public Holiday)";

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFBF2600),
          content: Row(
            children: [
              const Icon(Icons.block, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Cannot schedule: $alertMessage",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Routing Action: Navigate to Create Task -> ${targetDate.toLocal().toString().split(' ')[0]}",
        ),
      ),
    );
  }

  void _handleOnViewOrEdit(JiraTimeTask task) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Open View/Edit Screen -> ${task.title}")),
    );
  }

  String _getAppBarTitle(DateTime date, CalendarViewMode mode) {
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
    if (mode == CalendarViewMode.day) {
      return "${date.day} ${months[date.month - 1]} ${date.year}";
    }
    return "${months[date.month - 1]} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: const Color(0xFF0747A6),
        title: ListenableBuilder(
          listenable: _provider,
          builder: (context, _) => Text(
            _getAppBarTitle(_provider.focusedDate, _provider.viewMode),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: Colors.white,
            ),
            onPressed: _provider.previous,
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white,
            ),
            onPressed: _provider.next,
          ),
          ListenableBuilder(
            listenable: _provider,
            builder: (context, _) => PopupMenuButton<CalendarViewMode>(
              icon: const Icon(Icons.calendar_view_day, color: Colors.white),
              onSelected: _provider.setViewMode,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: CalendarViewMode.month,
                  child: Text("Month View"),
                ),
                const PopupMenuItem(
                  value: CalendarViewMode.week,
                  child: Text("Week View"),
                ),
                const PopupMenuItem(
                  value: CalendarViewMode.day,
                  child: Text("Day View"),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _provider,
        builder: (context, child) {
          return IndexedStack(
            index: _provider.viewMode.index,
            children: [
              JiraMonthView(
                provider: _provider,
                onCreate: _handleOnCreate,
                onTaskTap: _handleOnViewOrEdit,
              ),
              JiraWeekView(
                provider: _provider,
                onCreate: _handleOnCreate,
                onTaskTap: _handleOnViewOrEdit,
              ),
              JiraDayView(
                provider: _provider,
                onCreate: _handleOnCreate,
                onTaskTap: _handleOnViewOrEdit,
              ),
            ],
          );
        },
      ),
    );
  }
}
