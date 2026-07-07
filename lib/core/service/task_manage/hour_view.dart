import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model.dart';
import 'painter.dart';

class TaskHourView extends StatelessWidget {
  final Function(JiraTimeTask) onTaskTap;
  final DateTime activeDate;
  final List<JiraTimeTask> tasks;
  final Function(DateTime) normalize;
  const TaskHourView({
    super.key,
    required this.onTaskTap,
    required this.tasks,
    required this.activeDate,
    required this.normalize,
  });
  final double hourRowHeight = 80.0;
  final int startHour = 9;
  final int endHour = 17;

  @override
  Widget build(BuildContext context) {
    final int totalHours = endHour - startHour + 1;
    final double canvasHeight = totalHours * hourRowHeight;
    return SingleChildScrollView(
      child: SizedBox(
        height: canvasHeight,
        child: Row(
          children: [
            SizedBox(width: 50, child: _buildTimeColumn(totalHours)),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      _buildGrid(
                        constraints.maxWidth,
                        canvasHeight,
                        totalHours,
                      ),
                      ..._buildTaskCards(constraints.maxWidth),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Update filtering logic to use provider state
  List<Widget> _buildTaskCards(double canvasWidth) {
    return tasks
        .where((task) {
          final DateTime? activeNormalized = normalize(activeDate);
          final DateTime startNormalized = normalize(task.startTime);
          final DateTime endNormalized = normalize(task.endTime);

          final bool matchesDate =
              activeNormalized == null ||
              (activeNormalized.isAtSameMomentAs(startNormalized) ||
                      activeNormalized.isAfter(startNormalized)) &&
                  (activeNormalized.isAtSameMomentAs(endNormalized) ||
                      activeNormalized.isBefore(endNormalized));

          // 3. Keep your hour range filter
          final bool inRange =
              task.startTime.hour >= startHour && task.startTime.hour < endHour;

          return matchesDate && inRange;
        })
        .toList()
        .map((task) {
          return Positioned(
            top: (task.startTime.hour - startHour) * hourRowHeight,
            left: 0,
            width: canvasWidth - 8,
            height: 70,
            child: GestureDetector(
              onTap: () => onTaskTap(task),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: task.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border(left: BorderSide(color: task.color, width: 4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ), // Ensure you have this import
                    // ... inside your build method
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: DateFormat('h:mm a').format(task.startTime),
                            // Optional styling
                          ),
                          const TextSpan(text: " - "), // Add a separator
                          TextSpan(
                            text: DateFormat('h:mm a').format(task.endTime),
                          ),
                        ],
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        ), // Shared style
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        })
        .toList();
  }

  Widget _buildTimeColumn(int totalHours) {
    return Column(
      children: List.generate(totalHours, (i) {
        final int hour = startHour + i;
        final String period = hour >= 12 ? 'PM' : 'AM';
        // Convert to 12-hour format for display (e.g., 13 becomes 1)
        final int displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

        return SizedBox(
          height: hourRowHeight,
          child: Text(
            "$displayHour $period",
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        );
      }),
    );
  }

  Widget _buildGrid(double width, double height, int totalHours) {
    return CustomPaint(
      size: Size(width, height),
      painter: TimelineGridPainter(
        lineCount: totalHours,
        rowHeight: hourRowHeight,
        lineColor: Colors.grey.shade200,
      ),
    );
  }
}
