import 'package:flutter/rendering.dart';

import 'core/core.dart';

abstract class FirebaseInjection {
  static Future<void> initFirebaseServices() async {
    final options = FirebaseOptions(
      apiKey: "AIzaSyDqdwGdHUkghv8Iaydq0uG4IcGF0cYuWw",
      appId: "1:432071418438:android:588d784d19c971b92a204",
      messagingSenderId: "432071418438",
      projectId: "paypass-97314",
    );

    final instance = NotificationService.instance;
    await instance.initialize(
      options: options,
      onNavigate: (data) => _handleNavigation(data),
      onPermissionResult: (status) => debugPrint('Permission: $status'),
      backgroundMsgCallback: (data) async =>
          debugPrint('Background msg: ${data.messageId}'),
    );

    final fcmToken = await instance.getToken();
    debugPrint('FCM Token: $fcmToken');
  }

  static void _handleNavigation(Map<String, dynamic> data) {
    final screen = data['screen'];
    if (screen == RouteName.calculator.path) {
      AppRouter.router.push(RouteName.calculator.path);
    }
  }
}
