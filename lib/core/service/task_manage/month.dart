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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const .symmetric(vertical: 6.0, horizontal: 4.0),
          child: SizedBox(
            height: 30, // Define a height for the header row
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: provider.weekdayNames.length,
              itemBuilder: (context, index) {
                final double itemWidth = MediaQuery.of(context).size.width / 7;
                return SizedBox(
                  width: itemWidth,
                  child: Center(
                    child: Text(
                      provider.weekdayNames[index],
                      style: TextStyle(
                        fontSize: 12,
                        color: provider.weekdayNames[index].contains('S')
                            ? Theme.of(context).colorScheme.error
                            : null,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        ListenableBuilder(
          listenable: provider,
          builder: (context, _) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const .all(4),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: provider.getWeekDays().length,
                childAspectRatio: 1.1,
              ),
              itemCount: provider.generateMonthDays().length,
              itemBuilder: (context, index) {
                final day = provider.generateMonthDays()[index];
                final dayTasks = provider.getTasksForDay(day);
                final activeDate = provider.activeDate;
                final isSelectedDate =
                    activeDate != null &&
                    day.year == activeDate.year &&
                    day.month == activeDate.month &&
                    day.day == activeDate.day;
                return GestureDetector(
                  onTap: () => provider.setActiveDate(day),
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Date Number Circle
                        CircleAvatar(
                          backgroundColor: isSelectedDate
                              ? null
                              : Colors.transparent,
                          child: Text(
                            "${day.day}",
                            style: TextStyle(
                              fontSize: 14,
                              color: provider.isWeekend(day)
                                  ? Theme.of(context).colorScheme.error
                                  : null,
                              fontWeight: isSelectedDate
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (dayTasks.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: dayTasks.map((t) {
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
            onCreate: (date) => onCreate(date),
            tasks: provider.getTasksForRange(provider.getActiveTasks()),
            provider: provider,
          ),
        ),
      ],
    );
  }
}
