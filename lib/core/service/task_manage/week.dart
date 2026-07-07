import 'package:firebaseappdistribution/core/service/task_manage/hour_view.dart';
import 'package:flutter/material.dart';
import 'model.dart';
import 'provider.dart';

class JiraWeekView extends StatefulWidget {
  final JiraTimeCalendarProvider provider;
  final Function(DateTime) onCreate;
  final Function(JiraTimeTask) onTaskTap;

  const JiraWeekView({
    super.key,
    required this.provider,
    required this.onCreate,
    required this.onTaskTap,
  });

  @override
  State<JiraWeekView> createState() => _JiraWeekViewState();
}

class _JiraWeekViewState extends State<JiraWeekView> {
  // REMOVED local _activeDate state

  @override
  Widget build(BuildContext context) {
    final DateTime startOfWeek = widget.provider.focusedDate.subtract(
      Duration(days: widget.provider.focusedDate.weekday - 1),
    );
    final List<DateTime> weekDays = List.generate(
      7,
      (i) => startOfWeek.add(Duration(days: i)),
    );

    return Column(
      children: [
        // --- Header ---
        ListenableBuilder(
          listenable: widget.provider,
          builder: (context, _) {
            final activeDate = widget.provider.activeDate;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final day = weekDays[index];
                  final bool isSelected =
                      activeDate != null &&
                      activeDate.year == day.year &&
                      activeDate.month == day.month &&
                      activeDate.day == day.day;

                  return GestureDetector(
                    onTap: () =>
                        widget.provider.setActiveDate(isSelected ? null : day),
                    child: Column(
                      children: [
                        Text(
                          [
                            "Mon",
                            "Tue",
                            "Wed",
                            "Thu",
                            "Fri",
                            "Sat",
                            "Sun",
                          ][index],
                          style: TextStyle(
                            fontSize: 12,
                            color: widget.provider.isWeekend(day)
                                ? Colors.red
                                : (isSelected ? Colors.black : Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.black
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "${day.day}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: widget.provider.isWeekend(day)
                                  ? Colors.red
                                  : (isSelected ? Colors.white : Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            );
          },
        ),
        const Divider(),
        Expanded(
          child: TaskHourView(
            onTaskTap: widget.onTaskTap,
            tasks: widget.provider.getActiveTasks(),
            activeDate: widget.provider.activeDate!,
            normalize: (d) => widget.provider.normalize(d),
          ),
        ),
      ],
    );
  }
}
