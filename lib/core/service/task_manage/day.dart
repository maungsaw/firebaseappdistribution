import 'package:flutter/material.dart';

import 'model.dart';
import 'painter.dart';
import 'provider.dart';

class JiraDayView extends StatelessWidget {
  final JiraTimeCalendarProvider provider;
  final Function(DateTime) onCreate;
  final Function(JiraTimeTask) onTaskTap;

  final double hourRowHeight = 65.0;
  final int startHour = 9;
  final int endHour = 20;

  const JiraDayView({
    super.key,
    required this.provider,
    required this.onCreate,
    required this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    final int totalHours = endHour - startHour + 1;
    final double totalCanvasHeight = totalHours * hourRowHeight;

    // Range-aware single day filter interception
    final dayTasks = provider.tasks.where((task) {
      final cleanDay = DateTime(
        provider.focusedDate.year,
        provider.focusedDate.month,
        provider.focusedDate.day,
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
      return !cleanDay.isBefore(cleanStart) && !cleanDay.isAfter(cleanEnd);
    }).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        height: totalCanvasHeight + 20,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 70,
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: List.generate(
                  totalHours,
                  (index) => SizedBox(
                    height: hourRowHeight,
                    child: Text(
                      _formatHour(startHour + index),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 28, right: 12),
                height: totalCanvasHeight,
                child: GestureDetector(
                  onTapUp: (details) {
                    final double tapY = details.localPosition.dy;
                    final double hourDelta = tapY / hourRowHeight;
                    final int tappedHour = startHour + hourDelta.floor();
                    final int tappedMinute =
                        ((hourDelta - hourDelta.floor()) * 60).round();

                    final targetDateTime = DateTime(
                      provider.focusedDate.year,
                      provider.focusedDate.month,
                      provider.focusedDate.day,
                      tappedHour,
                      tappedMinute,
                    );
                    onCreate(targetDateTime);
                  },
                  child: CustomPaint(
                    painter: TimelineGridPainter(
                      lineCount: totalHours,
                      rowHeight: hourRowHeight,
                      lineColor: Colors.grey.shade100,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: dayTasks.map((task) {
                            // Compute localized layout clipping offsets for multi-day range entries
                            final bool startsBeforeToday = task.startTime
                                .isBefore(
                                  DateTime(
                                    provider.focusedDate.year,
                                    provider.focusedDate.month,
                                    provider.focusedDate.day,
                                  ),
                                );
                            final int effectiveStartHour = startsBeforeToday
                                ? startHour
                                : task.startTime.hour;
                            final int effectiveStartMinute = startsBeforeToday
                                ? 0
                                : task.startTime.minute;

                            final bool endsAfterToday = task.endTime.isAfter(
                              DateTime(
                                provider.focusedDate.year,
                                provider.focusedDate.month,
                                provider.focusedDate.day,
                                endHour,
                                59,
                              ),
                            );
                            final int effectiveEndHour = endsAfterToday
                                ? endHour
                                : task.endTime.hour;
                            final int effectiveEndMinute = endsAfterToday
                                ? 59
                                : task.endTime.minute;

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
                              top: topOffset,
                              height: height,
                              width: constraints.maxWidth,
                              child: GestureDetector(
                                onTap: () {},
                                child: InkWell(
                                  onTap: () => onTaskTap(task),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 1,
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: task.color,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Metadata Row: Status & Start/End Time String Output
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${_formatTime(task.startTime)} - ${_formatTime(task.endTime)}",
                                              style: TextStyle(
                                                color: Colors.white.withValues(
                                                  alpha: 0.9,
                                                ),
                                                fontSize: 9,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            _buildStatusBadge(task.status),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          task.title,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: height < 50 ? 1 : 2,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (task.remark != null &&
                                            height > 60) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            task.remark!,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white.withValues(
                                                alpha: 0.8,
                                              ),
                                              fontSize: 10,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatHour(int hour) =>
      hour >= 12 ? "${hour == 12 ? 12 : hour - 12} PM" : "$hour AM";

  String _formatTime(DateTime dt) {
    final String minuteStr = dt.minute.toString().padLeft(2, '0');
    final int hour = dt.hour;
    final String amPm = hour >= 12 ? "PM" : "AM";
    final int displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return "$displayHour:$minuteStr $amPm";
  }

  Widget _buildStatusBadge(JiraStatus status) {
    String label = "TO DO";
    Color labelColor = const Color(0xFF42526E);
    Color bgColor = const Color(0xFFF4F5F7);

    switch (status) {
      case JiraStatus.inProgress:
        label = "IN PROGRESS";
        labelColor = const Color(0xFF0052CC);
        bgColor = const Color(0xFFDEEBFF);
        break;
      case JiraStatus.done:
        label = "DONE";
        labelColor = const Color(0xFF006644);
        bgColor = const Color(0xFFE3FCEF);
        break;
      case JiraStatus.toDo:
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: labelColor,
          fontSize: 8,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
