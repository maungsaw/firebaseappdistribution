import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class ForegroundScheculerService {
  void initTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'sync_channel_id', // Use a unique ID
        channelName: 'Syncing Data',
        channelDescription: 'App is syncing in the background',
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(2000),
        autoRunOnBoot: true,
        allowWakeLock: true,
      ),
    );
  }

  Future<void> startTask(Function startCallback) async {
    // 1. Request necessary permissions first
    await FlutterForegroundTask.requestNotificationPermission();

    // 2. Start the service
    await FlutterForegroundTask.startService(
      notificationTitle: 'Syncing Data',
      notificationText: 'Please wait...',
      callback: startCallback,
    );
  }

  void stopTask() {
    FlutterForegroundTask.stopService();
  }
}
