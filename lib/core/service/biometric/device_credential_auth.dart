import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'device_auth_service.dart';

/// Android fallback using KeyguardManager device credential intent.
/// Works on Huawei/Honor and other devices where local_auth reports unsupported.
class DeviceCredentialAuth {
  static const MethodChannel _channel = MethodChannel(
    'com.sawhtunaung.firebaseappdistribution/device_credential',
  );

  static bool get isAndroid => Platform.isAndroid;

  static Future<bool> isDeviceSecure() async {
    if (!isAndroid) return false;
    try {
      final secure = await _channel.invokeMethod<bool>('isDeviceSecure');
      return secure ?? false;
    } on PlatformException catch (e) {
      debugPrint('DeviceCredentialAuth.isDeviceSecure: ${e.code} ${e.message}');
      return false;
    }
  }

  static Future<DeviceAuthResult> authenticate({
    String title = 'Phone Security Required',
    String description = 'Use your phone PIN, pattern, or password',
  }) async {
    if (!isAndroid) {
      return const DeviceAuthResult(
        success: false,
        errorCode: 'NotAvailable',
        errorMessage: 'Device credential auth is only available on Android.',
      );
    }

    try {
      final response = await _channel.invokeMapMethod<String, dynamic>(
        'authenticate',
        {
          'title': title,
          'description': description,
        },
      );

      final success = response?['success'] == true;
      if (success) {
        return const DeviceAuthResult(success: true);
      }

      return DeviceAuthResult(
        success: false,
        errorCode: response?['errorCode'] as String? ?? 'cancelled',
      );
    } on PlatformException catch (e) {
      debugPrint('DeviceCredentialAuth.authenticate: ${e.code} ${e.message}');
      return DeviceAuthResult(
        success: false,
        errorCode: e.code,
        errorMessage: e.message,
      );
    }
  }
}
