import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../core.dart';

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

      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        await PushTokenService.saveFcmToken(token);
        debugPrint('FCM Token refreshed: $token');
      });

      try {
        final fcmToken = await instance.getToken();
        await PushTokenService.saveFcmToken(fcmToken);
        if (fcmToken != null && fcmToken.isNotEmpty) {
          debugPrint('FCM Token: $fcmToken');
        } else {
          debugPrint('FCM Token empty — Pushy may be used for Chinese phones');
        }
      } catch (e) {
        debugPrint(
          'FCM token unavailable. Pushy will be used if available: $e',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Firebase services init skipped: $e');
      debugPrint('$stackTrace');
    }
  }
}
