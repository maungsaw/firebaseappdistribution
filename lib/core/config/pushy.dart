import 'package:firebaseappdistribution/core/core.dart';
import 'package:flutter/foundation.dart';

abstract class PushyInjection {
  static Future<void> initPushyServices() async {
    try {
      await PushyService.instance.initialize(
        onNavigate: NotificationActions.handleNotificationNavigation,
      );
    } catch (e, stackTrace) {
      debugPrint('Pushy services init skipped: $e');
      debugPrint('$stackTrace');
    }
  }
}
