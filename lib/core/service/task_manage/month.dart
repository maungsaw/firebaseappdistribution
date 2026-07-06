import 'package:flutter/material.dart';

import 'model.dart';
import 'provider.dart';
import 'widget.dart';

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
        // 1. Static Weekday Header Row
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            children: List.generate(7, (index) {
              final isWeekendHeader =
                  index == 5 || index == 6; // Sat and Sun indices
              return Expanded(
                child: Center(
                  child: Text(
                    weekdayNames[index],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isWeekendHeader
                          ? Colors.grey.shade500
                          : const Color(
                              0xFF5E6C84,
                            ), // Jira mid-grey text representation
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        // 2. Main Calendar Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.75,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];

              // Dynamic Range Validation Check
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

              final isCurrentMonth = day.month == provider.focusedDate.month;
              final isWeekend = provider.isWeekend(day);
              final holiday = provider.getHoliday(day);

              Color cellBgColor = Colors.white;
              if (holiday != null) {
                cellBgColor = const Color(0xFFFFEBE6);
              } else if (isWeekend) {
                cellBgColor = const Color(0xfff4f5f7);
              }

              return GestureDetector(
                onTap: () => onCreate(day),
                child: Container(
                  color: cellBgColor,
                  child: Container(
                    decoration: BorderBoxDecoration.cellBorder,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${day.day}",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isCurrentMonth
                                      ? Colors.black87
                                      : Colors.black26,
                                ),
                              ),
                              if (holiday != null && isCurrentMonth)
                                Expanded(
                                  child: Text(
                                    holiday.name,
                                    textAlign: TextAlign.end,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 8,
                                      color: Color(0xFFBF2600),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: dayTasks
                                .map(
                                  (t) => GestureDetector(
                                    onTap: () => onTaskTap(t),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 1,
                                        horizontal: 2,
                                      ),
                                      height:
                                          12, // Increased task height slightly from 2 to 12 for scannable visibility
                                      decoration: BoxDecoration(
                                        color: t.color,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
