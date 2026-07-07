import 'package:flutter/material.dart';

import 'hour_view.dart';
import 'model.dart';
import 'provider.dart';

class JiraMonthView extends StatelessWidget {
  final JiraTimeCalendarProvider provider;
  final Function(DateTime) onCreate;
  final Function(JiraTimeTask) onTaskTap;

  const JiraMonthView({
    super.key,
    required this.provider,
    required this.onCreate,
    required this.onTaskTap,
  });

  List<DateTime> _generateMonthDays(DateTime date) {
    final first = DateTime(date.year, date.month, 1);
    final last = DateTime(date.year, date.month + 1, 0);
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

  @override
  Widget build(BuildContext context) {
    final days = _generateMonthDays(provider.focusedDate);
    const weekdayNames = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    return Column(
      children: [
        // 1. Static Weekday Header Row (Clean, no background)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
          child: Row(
            children: List.generate(7, (index) {
              return Expanded(
                child: Center(
                  child: Text(
                    weekdayNames[index],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        ListenableBuilder(
          listenable: provider,
          builder: (context, _) {
            return GridView.builder(
              shrinkWrap: true, // ADD THIS
              physics: const NeverScrollableScrollPhysics(), // ADD THIS
              padding: const EdgeInsets.all(4),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio:
                    1.1, // Adjusted for a squarer, cleaner look like the image
              ),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];

                final dayTasks = provider.tasks.where((task) {
                  final cleanDay = DateTime(day.year, day.month, day.day);
                  final cleanStart = DateTime(
                    task.startTime.year,
                    task.startTime.month,
                    task.startTime.day,
                  );
                  final cleanEnd = DateTime(
                    task.endTime.year,
                    task.endTime.month,
                    task.endTime.day,
                  );
                  return !cleanDay.isBefore(cleanStart) &&
                      !cleanDay.isAfter(cleanEnd);
                }).toList();
                final activeDate = provider.activeDate;
                final isSelectedDate =
                    activeDate != null &&
                    day.year == activeDate.year &&
                    day.month == activeDate.month &&
                    day.day == activeDate.day;
                final isCurrentMonth = day.month == provider.focusedDate.month;

                return GestureDetector(
                  onTap: () {
                    provider.setActiveDate(day);
                    onCreate(day);
                  },
                  child: Container(
                    color: Colors.transparent, // Removed heavy cell backgrounds
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Date Number Circle
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isSelectedDate
                                ? Colors.black
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "${day.day}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelectedDate
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelectedDate
                                  ? Colors.white
                                  : (isCurrentMonth
                                        ? Colors.black87
                                        : Colors.black26),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Task Dot Indicators (up to 3 dots)
                        if (dayTasks.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: dayTasks.take(3).map((t) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 1.5,
                                ),
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: t.color,
                                  shape: BoxShape.circle,
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        Expanded(
          child: TaskHourView(
            onTaskTap: onTaskTap,
            tasks: provider.getActiveTasks(),
            activeDate: provider.activeDate!,
            normalize: (d) => provider.normalize(d),
          ),
        ),
      ],
    );
  }
}
