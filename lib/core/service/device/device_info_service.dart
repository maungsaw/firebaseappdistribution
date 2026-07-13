import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfoService {
  DeviceInfoService._();

  static final DeviceInfoPlugin _plugin = DeviceInfoPlugin();
  static String? _cachedDeviceId;
  static String? _cachedModel;

  @visibleForTesting
  static String? testDeviceId;

  @visibleForTesting
  static void clearCacheForTesting() {
    _cachedDeviceId = null;
    _cachedModel = null;
    testDeviceId = null;
  }

  /// Stable per-device identifier used for secret key derivation.
  static Future<String> getDeviceId() async {
    if (testDeviceId != null) return testDeviceId!;
    if (_cachedDeviceId != null) return _cachedDeviceId!;

    final id = await _readDeviceId();
    _cachedDeviceId = id;
    return id;
  }

  static Future<String> getModel() async {
    if (_cachedModel != null) return _cachedModel!;

    final model = await _readModel();
    _cachedModel = model;
    return model;
  }

  /// Logs device ID and model to the debug console only.
  static Future<void> logToDebugConsole() async {
    if (!kDebugMode) return;

    try {
      final id = await getDeviceId();
      final model = await getModel();
      debugPrint('[Device] id=$id model=$model');
    } catch (error, stackTrace) {
      debugPrint('[Device] failed to read device info: $error');
      debugPrint('$stackTrace');
    }
  }

  static Future<String> _readDeviceId() async {
    if (Platform.isAndroid) {
      final info = await _plugin.androidInfo;
      final id = info.id.trim();
      if (id.isEmpty) {
        throw StateError('Android device ID is empty');
      }
      return id;
    }

    if (Platform.isIOS) {
      final info = await _plugin.iosInfo;
      final id = info.identifierForVendor?.trim();
      if (id == null || id.isEmpty) {
        throw StateError('iOS identifierForVendor is unavailable');
      }
      return id;
    }

    throw UnsupportedError('Device ID is not supported on this platform');
  }

  static Future<String> _readModel() async {
    if (Platform.isAndroid) {
      final info = await _plugin.androidInfo;
      return info.model;
    }

    if (Platform.isIOS) {
      final info = await _plugin.iosInfo;
      return info.model;
    }

    return 'unsupported';
  }
}
