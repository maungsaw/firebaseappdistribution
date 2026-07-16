import 'dart:io' show Platform;

import 'package:firebaseappdistribution/core/service/notification/notification_actions.dart';
import 'package:flutter/foundation.dart';
import 'package:pushy_flutter/pushy_flutter.dart';

@pragma('vm:entry-point')
Future<void> pushyBackgroundNotificationListener(
  Map<String, dynamic> data,
) async {
  debugPrint('Pushy notification received: $data');

  await NotificationActions.performRemoteWipeIfRequested(data);

  final title = data['title']?.toString() ?? 'Insurance App';
  final body =
      data['message']?.toString() ??
      data['body']?.toString() ??
      'You have a new notification';

  if (Platform.isAndroid) {
    Pushy.notify(title, body, data);
  }

  Pushy.clearBadge();
}
