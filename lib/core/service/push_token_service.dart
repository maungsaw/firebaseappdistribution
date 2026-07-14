import 'dart:io' show Platform;

import 'package:firebaseappdistribution/core/service/pushy/pushy_service.dart';
import 'package:firebaseappdistribution/data/data.dart';
import 'package:flutter/foundation.dart';

/// Resolves the best available push token for device registration.
/// FCM first; on Huawei/Chinese phones without GMS, falls back to Pushy.
class PushTokenService {
  PushTokenService._();

  static Future<String?> resolve() async {
    final fcmToken = await _readValidToken('fcm-token');
    if (fcmToken != null) {
      debugPrint('[PushToken] using FCM token');
      return fcmToken;
    }

    var pushyToken = await _readValidToken('pushy-token');
    if (pushyToken != null) {
      debugPrint('[PushToken] using cached Pushy token');
      return pushyToken;
    }

    if (Platform.isAndroid) {
      pushyToken = await PushyService.instance.registerDevice();
      if (pushyToken != null && pushyToken.isNotEmpty) {
        debugPrint('[PushToken] refreshed Pushy token');
        return pushyToken;
      }
    }

    debugPrint('[PushToken] no push token available');
    return null;
  }

  static Future<String?> _readValidToken(String key) async {
    final value = await LocalCacheService.read(key);
    if (value == null || value.isEmpty || value == 'null') return null;
    return value;
  }
}
