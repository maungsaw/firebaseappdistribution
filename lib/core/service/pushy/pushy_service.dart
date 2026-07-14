import 'dart:io' show Platform;

import 'package:firebaseappdistribution/core/service/push_token_service.dart';
import 'package:firebaseappdistribution/core/service/pushy/pushy_background.dart';
import 'package:firebaseappdistribution/data/data.dart';
import 'package:flutter/foundation.dart';
import 'package:pushy_flutter/pushy_flutter.dart';

typedef PushyNavigationCallback = void Function(Map<String, dynamic> data);

class PushyService {
  PushyService._();

  static final PushyService instance = PushyService._();

  bool _initialized = false;
  PushyNavigationCallback? _onNavigate;

  Future<void> initialize({required PushyNavigationCallback onNavigate}) async {
    if (_initialized || !Platform.isAndroid) return;

    _onNavigate = onNavigate;

    Pushy.listen();
    Pushy.toggleInAppBanner(true);
    Pushy.setNotificationListener(pushyBackgroundNotificationListener);
    Pushy.setNotificationClickListener(_onNotificationClick);

    try {
      Pushy.toggleFCM(true);
    } catch (e) {
      debugPrint('Pushy FCM fallback not enabled yet: $e');
    }

    _initialized = true;
    await registerDevice();
  }

  Future<String?> registerDevice() async {
    if (!Platform.isAndroid) return null;

    try {
      final deviceToken = await Pushy.register();
      if (deviceToken.isEmpty) {
        debugPrint('Pushy registration returned empty token');
        return null;
      }
      await LocalCacheService.write(
        PushTokenService.pushyCacheKey,
        deviceToken,
      );
      debugPrint('Pushy device token: $deviceToken');
      return deviceToken;
    } catch (e, stackTrace) {
      debugPrint('Pushy registration failed: $e');
      debugPrint('$stackTrace');
      return null;
    }
  }

  void _onNotificationClick(Map<String, dynamic> data) {
    debugPrint('Pushy notification click: $data');
    Pushy.clearBadge();
    _onNavigate?.call(data);
  }
}
