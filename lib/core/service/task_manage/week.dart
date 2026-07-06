import 'package:flutter/material.dart';

import 'model.dart';
import 'painter.dart';
import 'provider.dart';
import 'widget.dart';

class JiraWeekView extends StatelessWidget {
  final JiraTimeCalendarProvider provider;
  final Function(DateTime) onCreate;
  final Function(JiraTimeTask) onTaskTap;

  final double hourRowHeight = 65.0;
  final int startHour = 9;
  final int endHour = 20;

  const JiraWeekView({
    super.key,
    required this.provider,
    required this.onCreate,
    required this.onTaskTap,
  });

  List<DateTime> _getWeekDays(DateTime date) {
    final int currentWeekday = date.weekday;
    final DateTime startOfWeek = date.subtract(
      Duration(days: currentWeekday - 1),
    );
    return List.generate(
      7,
      (i) => DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + i),
    );
  }

  String _formatHour(int hour) =>
      hour >= 12 ? "${hour == 12 ? 12 : hour - 12} PM" : "$hour AM";

  @override
  Widget build(BuildContext context) {
    final weekDays = _getWeekDays(provider.focusedDate);
    final weekStart = DateTime(
      weekDays.first.year,
      weekDays.first.month,
      weekDays.first.day,
    );
    final weekEnd = DateTime(
      weekDays.last.year,
      weekDays.last.month,
      weekDays.last.day,
      23,
      59,
      59,
    );

    final int totalHours = endHour - startHour + 1;
    final double totalCanvasHeight = totalHours * hourRowHeight;

    // Filter tasks that belong to this week
    final visibleTasks = provider.tasks
        .where(
          (t) => t.startTime.isBefore(weekEnd) && t.endTime.isAfter(weekStart),
        )
        .toList();

    return Column(
      children: [
        // 1. Fixed Header: Row of Weekdays
        Row(
          children: [
            const SizedBox(width: 60), // Align with time column spacer
            ...List.generate(7, (index) {
              final day = weekDays[index];
              final isWeekend = provider.isWeekend(day);
              final holiday = provider.getHoliday(day);

              Color headerBg = isWeekend
                  ? const Color(0xFFF4F5F7)
                  : Colors.white;
              if (holiday != null) headerBg = const Color(0xFFFFEBE6);

              return Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: headerBg,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                      right: BorderSide(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                    ),
                  ),
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
                          fontSize: 10,
                          color: isWeekend ? Colors.grey : Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${day.day}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),

        // 2. Scrollable Canvas Body: Hours Sidebar + Intercept Canvas Grid
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: totalCanvasHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hour Sidebar column
                  SizedBox(
                    width: 60,
                    child: Column(
                      children: List.generate(
                        totalHours,
                        (index) => SizedBox(
                          height: hourRowHeight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              _formatHour(startHour + index),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Main Interactive 7-Day Grid Canvas Layout
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final double columnWidth = constraints.maxWidth / 7;

                        return Stack(
                          children: [
                            // Background lanes grid mapping
                            Row(
                              children: List.generate(7, (index) {
                                final day = weekDays[index];
                                final isWeekend = provider.isWeekend(day);
                                final holiday = provider.getHoliday(day);

                                Color colBgColor = isWeekend
                                    ? const Color(
                                        0xFFF4F5F7,
                                      ).withValues(alpha: .5)
                                    : Colors.white;
                                if (holiday != null) {
                                  colBgColor = Color(
                                    0xFFFFEBE6,
                                  ).withValues(alpha: .6);
                                }

                                return GestureDetector(
                                  onTapUp: (details) {
                                    final double tapY =
                                        details.localPosition.dy;
                                    final double hourDelta =
                                        tapY / hourRowHeight;
                                    final int tappedHour =
                                        startHour + hourDelta.floor();
                                    final int tappedMinute =
                                        ((hourDelta - hourDelta.floor()) * 60)
                                            .round();

                                    final targetDateTime = DateTime(
                                      day.year,
                                      day.month,
                                      day.day,
                                      tappedHour,
                                      tappedMinute,
                                    );
                                    onCreate(targetDateTime);
                                  },
                                  child: Container(
                                    width: columnWidth,
                                    color: colBgColor,
                                    child: Container(
                                      decoration:
                                          BorderBoxDecoration.columnRightBorder,
                                    ),
                                  ),
                                );
                              }),
                            ),

                            // Background Horizontal Hourly Gridlines
                            IgnorePointer(
                              child: CustomPaint(
                                size: Size(
                                  constraints.maxWidth,
                                  totalCanvasHeight,
                                ),
                                painter: TimelineGridPainter(
                                  lineCount: totalHours,
                                  rowHeight: hourRowHeight,
                                  lineColor: Colors.grey.shade100,
                                ),
                              ),
                            ),

                            // Interactive Task Cards Positioning
                            ...visibleTasks
                                .map((task) {
                                  // Loop through each day of the week to check if the task covers it
                                  return List.generate(7, (dayIndex) {
                                    final currentDay = weekDays[dayIndex];
                                    final cleanDay = DateTime(
                                      currentDay.year,
                                      currentDay.month,
                                      currentDay.day,
                                    );
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

                                    // Check if task intercepts this column day slot
                                    if (cleanDay.isBefore(cleanStart) ||
                                        cleanDay.isAfter(cleanEnd)) {
                                      return const SizedBox.shrink();
                                    }

                                    // Localize hours matching today's bounds
                                    final bool startsBeforeToday = task
                                        .startTime
                                        .isBefore(cleanDay);
                                    final int effectiveStartHour =
                                        startsBeforeToday
                                        ? startHour
                                        : task.startTime.hour;
                                    final int effectiveStartMinute =
                                        startsBeforeToday
                                        ? 0
                                        : task.startTime.minute;

                                    final bool endsAfterToday = task.endTime
                                        .isAfter(
                                          cleanDay.add(
                                            Duration(
                                              hours: endHour,
                                              minutes: 59,
                                            ),
                                          ),
                                        );
                                    final int effectiveEndHour = endsAfterToday
                                        ? endHour
                                        : task.endTime.hour;
                                    final int effectiveEndMinute =
                                        endsAfterToday
                                        ? 59
                                        : task.endTime.minute;

                                    // Prevent out-of-bounds rendering outside the 9 AM - 8 PM tracking grid
                                    if (effectiveStartHour > endHour ||
                                        effectiveEndHour < startHour) {
                                      return const SizedBox.shrink();
                                    }

                                    final double topOffset =
                                        ((effectiveStartHour +
                                                (effectiveStartMinute / 60.0)) -
                                            startHour) *
                                        hourRowHeight;
                                    final double durationInHours =
                                        (effectiveEndHour +
                                            (effectiveEndMinute / 60.0)) -
                                        (effectiveStartHour +
                                            (effectiveStartMinute / 60.0));
                                    final double height =
                                        durationInHours * hourRowHeight;

                                    return Positioned(
                                      left: dayIndex * columnWidth,
                                      width: columnWidth,
                                      top: topOffset,
                                      height: height,
                                      child: GestureDetector(
                                        onTap:
                                            () {}, // Prevent card taps from hitting the grid below
                                        child: InkWell(
                                          onTap: () => onTaskTap(task),
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 0.5,
                                              horizontal: 2,
                                            ),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: task.color.withValues(
                                                alpha: 0.95,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  task.title,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: height < 40 ? 1 : 2,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1.1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                                })
                                .expand((widgets) => widgets),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
