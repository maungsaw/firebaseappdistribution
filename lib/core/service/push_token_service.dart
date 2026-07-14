import 'dart:io' show Platform;

import 'package:firebaseappdistribution/core/service/notification/service.dart';
import 'package:firebaseappdistribution/core/service/pushy/pushy_service.dart';
import 'package:firebaseappdistribution/data/data.dart';
import 'package:flutter/foundation.dart';

enum PushTokenSource { fcm, pushy }

class PushTokenResult {
  const PushTokenResult({
    required this.token,
    required this.source,
  });

  final String token;
  final PushTokenSource source;

  String get sourceLabel => source == PushTokenSource.fcm ? 'FCM' : 'Pushy';
}

/// Resolves push token for device registration.
///
/// Priority:
/// 1. Cached FCM token
/// 2. Live FCM [getToken] (GMS phones)
/// 3. Cached Pushy token
/// 4. Live Pushy register (Huawei / Chinese phones without GMS)
class PushTokenService {
  PushTokenService._();

  static const fcmCacheKey = 'fcm-token';
  static const pushyCacheKey = 'pushy-token';

  static Future<PushTokenResult?> resolve() async {
    final cachedFcm = await _readValidToken(fcmCacheKey);
    if (cachedFcm != null) {
      debugPrint('[PushToken] using cached FCM token');
      return PushTokenResult(token: cachedFcm, source: PushTokenSource.fcm);
    }

    final liveFcm = await _refreshFcmToken();
    if (liveFcm != null) {
      debugPrint('[PushToken] using live FCM token');
      return PushTokenResult(token: liveFcm, source: PushTokenSource.fcm);
    }

    final cachedPushy = await _readValidToken(pushyCacheKey);
    if (cachedPushy != null) {
      debugPrint('[PushToken] using cached Pushy token');
      return PushTokenResult(token: cachedPushy, source: PushTokenSource.pushy);
    }

    if (Platform.isAndroid) {
      final livePushy = await PushyService.instance.registerDevice();
      if (livePushy != null && livePushy.isNotEmpty && livePushy != 'null') {
        debugPrint('[PushToken] using live Pushy token');
        return PushTokenResult(
          token: livePushy,
          source: PushTokenSource.pushy,
        );
      }
    }

    debugPrint('[PushToken] neither FCM nor Pushy token available');
    return null;
  }

  /// Persist FCM token when Firebase succeeds / refreshes.
  static Future<void> saveFcmToken(String? token) async {
    if (!_isValid(token)) {
      debugPrint('[PushToken] skip saving empty FCM token');
      return;
    }
    await LocalCacheService.write(fcmCacheKey, token!);
    debugPrint('[PushToken] FCM token saved');
  }

  static Future<String?> _refreshFcmToken() async {
    try {
      final token = await NotificationService.instance.getToken();
      if (!_isValid(token)) return null;
      await saveFcmToken(token);
      return token;
    } catch (e) {
      debugPrint('[PushToken] FCM live refresh failed (will try Pushy): $e');
      return null;
    }
  }

  static Future<String?> _readValidToken(String key) async {
    final value = await LocalCacheService.read(key);
    if (!_isValid(value)) return null;
    return value;
  }

  static bool _isValid(String? value) =>
      value != null && value.isNotEmpty && value != 'null';
}
