import 'package:flutter/material.dart';

import 'day.dart';
import 'model.dart';
import 'month.dart';
import 'provider.dart';
import 'week.dart';

class JiraTimeCalendarView extends StatefulWidget {
  final List<JiraTimeTask> tasks;
  final List<CustomHoliday> holidays;
  final Function(DateTime) onTapCreate; // Note: Ensure this is correctly typed
  final Function(JiraTimeTask) onTapUpdate;

  const JiraTimeCalendarView({
    super.key,
    required this.tasks,
    required this.holidays,
    required this.onTapCreate,
    required this.onTapUpdate,
  });

  @override
  State<JiraTimeCalendarView> createState() => _JiraTimeCalendarViewState();
}

class _JiraTimeCalendarViewState extends State<JiraTimeCalendarView> {
  final provider = JiraTimeCalendarProvider();
  late PageController _pageController;
  final int _initialPage = 0;

  @override
  void initState() {
    super.initState();
    provider.setHours(9, 18);
    provider.updateTasks(widget.tasks);
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleOnCreate(DateTime targetDate) {
    widget.onTapCreate(targetDate);
  }

  void _handleOnViewOrEdit(JiraTimeTask task) {
    widget.onTapUpdate(task);
  }

  void _onArrowPressed(bool next) {
    if (next) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: ListenableBuilder(
          listenable: provider,
          builder: (context, _) => Text(
            provider.getAppBarTitle(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 16),
            onPressed: () => _onArrowPressed(false),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () => _onArrowPressed(true),
          ),
          ListenableBuilder(
            listenable: provider,
            builder: (context, _) => PopupMenuButton<CalendarViewMode>(
              icon: const Icon(Icons.calendar_view_day),
              onSelected: (mode) {
                provider.setViewMode(mode);
                _pageController.jumpToPage(
                  _initialPage,
                ); // Reset on mode change
              },
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
        listenable: provider,
        builder: (context, child) {
          return SizedBox.expand(
            child: PageView.builder(
              key: ValueKey(provider.viewMode),
              controller: _pageController,
              onPageChanged: (index) => provider.updateDateFromPageIndex(index),
              itemBuilder: (context, index) {
                switch (provider.viewMode) {
                  case CalendarViewMode.month:
                    return JiraMonthView(
                      provider: provider,
                      onCreate: _handleOnCreate,
                      onTaskTap: _handleOnViewOrEdit,
                    );
                  case CalendarViewMode.week:
                    return JiraWeekView(
                      provider: provider,
                      onCreate: _handleOnCreate,
                      onTaskTap: _handleOnViewOrEdit,
                    );
                  case CalendarViewMode.day:
                    return JiraDayView(
                      provider: provider,
                      onCreate: _handleOnCreate,
                      onTaskTap: _handleOnViewOrEdit,
                    );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
