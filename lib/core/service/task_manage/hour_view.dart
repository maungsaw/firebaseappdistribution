import 'package:firebaseappdistribution/core/service/task_manage/provider.dart';
import 'package:firebaseappdistribution/core/service/task_manage/widget.dart';
import 'package:flutter/material.dart';

import 'model.dart';
import 'painter.dart';

class TaskHourView extends StatelessWidget {
  final Function(JiraTimeTask) onTaskTap;
  final Function(DateTime date) onCreate;
  final JiraTimeCalendarProvider provider;
  final List<JiraTimeTask> tasks;
  const TaskHourView({
    super.key,
    required this.onTaskTap,
    required this.tasks,
    required this.provider,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final int totalHours = provider.endHour - provider.startHour + 1;
    final double canvasHeight = totalHours * provider.pixelsPerHour;
    return SingleChildScrollView(
      child: SizedBox(
        height: canvasHeight,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onLongPressStart: (LongPressStartDetails details) {
            final double y = details.localPosition.dy;
            final int tappedHour =
                provider.startHour + (y ~/ provider.pixelsPerHour);

            final DateTime targetDate = DateTime(
              provider.focusedDate.year,
              provider.focusedDate.month,
              provider.focusedDate.day,
              tappedHour,
            );

            onCreate(targetDate);
          },
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
      ),
    );
  }

  List<Widget> _buildTaskCards(double canvasWidth) {
    return tasks.map((task) {
      final double topOffset = provider.calculateTopOffset(task.startTime);
      final double taskHeight = provider.calculateTaskHeight(
        task.startTime,
        task.endTime,
      );

      return Positioned(
        top: topOffset,
        left: 0, // Or add a left offset if tasks overlap
        width: canvasWidth,
        height: taskHeight,
        child: JiraTaskCard(task: task, onTap: onTaskTap),
      );
    }).toList();
  }

  Widget _buildTimeColumn(int totalHours) {
    return Column(
      children: List.generate(totalHours, (i) {
        final int hour = provider.startHour + i;
        final String period = hour >= 12 ? 'PM' : 'AM';
        final int displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return SizedBox(
          height: provider.pixelsPerHour,
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
        rowHeight: provider.pixelsPerHour,
        lineColor: Colors.grey.shade200,
      ),
    );
  }
}
