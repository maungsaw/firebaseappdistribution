import 'package:dio/dio.dart';
import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';
import 'package:flutter/foundation.dart';

abstract class NotificationActions {
  /// Secure remote wipe entry for FCM / Pushy (foreground + background).
  ///
  /// Flow:
  /// 1. Validate HMAC signature + deviceId/userId/expiresAt/nonce
  /// 2. Best-effort `POST /devices/wipe-ack` with Bearer access token
  /// 3. Wipe local DB / cache / files
  static Future<void> performRemoteWipeIfRequested(
    Map<String, dynamic> data,
  ) async {
    final validation = await RemoteWipeSecurityService.validate(data);
    if (!validation.shouldWipe) {
      if (validation.isRejected) {
        logRemoteWipeRejection(validation.reason ?? 'Unknown reason');
      }
      return;
    }

    debugPrint('Security alert: Verified remote wipe command received.');
    AppTalker.info(
      'Remote wipe accepted '
      'commandId=${validation.commandId} userId=${validation.userId}',
    );

    // Ack while access_token still exists (before clearAll).
    await _acknowledgeWipeBestEffort(
      commandId: validation.commandId,
      deviceId: validation.deviceId,
      userId: validation.userId,
    );

    await DatabaseFileService.cleanDatabase();
    await LocalCacheService.clearAll();
    await FileStorageService.removeFolders();
    debugPrint('Success: App-wide local data has been securely deleted.');
    AppTalker.info('Remote wipe completed: local data deleted');
  }

  /// Calls wipe-ack with Bearer token. Never blocks the wipe on failure.
  static Future<void> _acknowledgeWipeBestEffort({
    String? commandId,
    String? deviceId,
    String? userId,
  }) async {
    if (commandId == null || commandId.isEmpty) {
      debugPrint('Wipe ack skipped: missing commandId');
      return;
    }

    try {
      final token = await LocalCacheService.read('access_token');
      if (token == null || token.isEmpty) {
        debugPrint('Wipe ack skipped: no access_token');
        return;
      }

      final resolvedDeviceId =
          (deviceId ?? await DeviceInfoService.getDeviceId()).trim();
      if (resolvedDeviceId.isEmpty) {
        debugPrint('Wipe ack skipped: empty deviceId');
        return;
      }

      final dio = Dio(
        BaseOptions(
          baseUrl: '${ApiClient.baseUrl}${ApiClient.clientVersion}',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          contentType: Headers.jsonContentType,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final path = ClientEndPoint.joinPath(
        ClientEndPoint.devices,
        ClientEndPoint.wipeAck,
      );
      final body = WipeAckRequestDto(
        commandId: commandId,
        deviceId: resolvedDeviceId,
        success: true,
      ).toMap();

      // OpenAPI body is command_id/device_id/success; userId is for audit logs.
      AppTalker.info(
        'Wipe ack → $path userId=${userId ?? '(none)'} '
        'commandId=$commandId deviceId=$resolvedDeviceId',
      );

      final response = await dio.post(path, data: body);
      debugPrint('Wipe ack response: ${response.statusCode} ${response.data}');
    } catch (error, stackTrace) {
      debugPrint('Wipe ack failed (wipe continues): $error');
      debugPrint('$stackTrace');
      AppTalker.warning('Wipe ack failed (wipe continues): $error');
    }
  }

  static void handleNotificationNavigation(Map<String, dynamic> data) {
    final screen = data['screen'];
    if (screen == AppRoutes.calculator) {
      AppRouter.router.push(AppRoutes.calculator);
    }
  }
}
