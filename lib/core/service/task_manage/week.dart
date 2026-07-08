import 'package:firebaseappdistribution/core/service/task_manage/hour_view.dart';
import 'package:flutter/material.dart';
import 'model.dart';
import 'provider.dart';

class JiraWeekView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListenableBuilder(
          listenable: provider,
          builder: (context, _) {
            final activeDate = provider.activeDate;
            return // Ensure this is wrapped in a Container or SizedBox with a fixed height
            Container(
              padding: .all(8),
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: provider.getWeekDays().length,
                itemBuilder: (context, index) {
                  final day = provider.getWeekDays()[index];
                  final bool isSelected =
                      activeDate != null &&
                      activeDate.year == day.year &&
                      activeDate.month == day.month &&
                      activeDate.day == day.day;

                  return GestureDetector(
                    onTap: () => provider.setActiveDate(day),
                    child: Container(
                      width: 50, // Set a specific width for each day cell
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(
                            provider.weekdayNames[index],
                            style: TextStyle(
                              fontSize: 12,
                              color: provider.isWeekend(day)
                                  ? Theme.of(context).colorScheme.error
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          CircleAvatar(
                            backgroundColor: isSelected
                                ? null
                                : Colors.transparent,
                            child: Text(
                              "${day.day}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: provider.isWeekend(day)
                                    ? Theme.of(context).colorScheme.error
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        const Divider(),
        Expanded(
          child: TaskHourView(
            onTaskTap: onTaskTap,
            onCreate: (date) => onCreate(date),
            tasks: provider.getTasksForRange(provider.getActiveTasks()),
            provider: provider,
          ),
        ),
      ],
    );
  }
}
