import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCalendar(
        view: CalendarView.workWeek,
        onTap: (calendarTapDetails) =>
            debugPrint("ON TAP -> {calendarTapDetails}"),
        dataSource: MeetingDataSource(_getDataSource()),
        timeSlotViewSettings: TimeSlotViewSettings(
          startHour: 9,
          endHour: 17,
          // Note: DateTime.friday and saturday are constants (5 and 6)
          nonWorkingDays: <int>[DateTime.sunday, DateTime.saturday],
        ),
      ),
    );
  }

  // Example method to populate the calendar
  List<Appointment> _getDataSource() {
    final List<Appointment> meetings = <Appointment>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(
      today.year,
      today.month,
      today.day,
      10,
      0,
      0,
    );
    final DateTime endTime = startTime.add(const Duration(hours: 2));

    meetings.add(
      Appointment(
        startTime: startTime,
        endTime: endTime,
        subject: 'Meeting',
        notes: 'Hello Calendar',
        color: Colors.blue,
      ),
    );
    meetings.add(
      Appointment(
        startTime: endTime.add(Duration(hours: 3)),
        endTime: endTime.add(Duration(hours: 4)),
        subject: 'Appoinment',
        notes: 'Hello Calendar',
        color: Colors.orange,
      ),
    );
    meetings.add(
      Appointment(
        startTime: endTime.add(Duration(hours: 1)),
        endTime: endTime.add(Duration(hours: 2)),
        subject: 'Other',
        notes: 'Hello Calendar',
        color: Colors.red,
      ),
    );
    return meetings;
  }
}

// Data source class required by SfCalendar
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
