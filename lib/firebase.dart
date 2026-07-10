import 'package:flutter/rendering.dart';

import 'core/core.dart';

abstract class FirebaseInjection {
  static Future<void> initFirebaseServices() async {
    try {
      final options = FirebaseOptions(
        apiKey: "AIzaSyDqdwGdHUkghv8Iaydq0uG4IcGF0cYuWw",
        appId: "1:432071418438:android:588d784d19c971b92a204",
        messagingSenderId: "432071418438",
        projectId: "paypass-97314",
      );

      final instance = NotificationService.instance;
      await instance.initialize(
        options: options,
        onNavigate: handleNotificationNavigation,
        onPermissionResult: (status) => debugPrint('Permission: $status'),
        backgroundMsgCallback: (data) async =>
            debugPrint('Background msg: ${data.messageId}'),
      );

      try {
        final fcmToken = await instance.getToken();
        LocalCacheService.write('fcm-token', fcmToken.toString());
        debugPrint('FCM Token: $fcmToken');
      } catch (e) {
        debugPrint(
          'FCM token unavailable. Push notifications disabled on this device: $e',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Firebase services init skipped: $e');
      debugPrint('$stackTrace');
    }
  }
}
