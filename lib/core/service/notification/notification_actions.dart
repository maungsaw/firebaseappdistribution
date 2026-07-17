import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/presentation/presentation.dart';
import 'package:flutter/foundation.dart';

import '../remote_wipe.dart';

abstract class NotificationActions {
  static Future<void> _performRemoteWipeIfRequested(
    VerifyWideDataResponse data,
  ) async {
    final validation = CryptoUtils.verifySignature(
      data.action,
      data.issuedAt.toString(),
      data.nonce,
      data.signature,
    );

    debugPrint('Security alert: Verified remote wipe command received.');
    if (validation) {
      AppTalker.info(
        'Remote wipe accepted '
        'commandId=${data.commandId} userId=${data.userId}',
      );
      final handler = RemoteWipeHandler(
        Injection.sl<RemoteWipeBloc>(),
        Injection.sl<AuthBloc>(),
      );
      await handler.executeWipe(data);
    } else {
      AppTalker.error(
        'Remote wipe rejected: signature verification failed '
        'commandId=${data.commandId} userId=${data.userId}',
      );
    }
  }

  static void handleNotificationNavigation(Map<String, dynamic> data) {
    final screen = data['screen'];
    if (screen == AppRoutes.calculator) {
      AppRouter.router.push(AppRoutes.calculator);
    }
  }

  static Future<void> checkWipePermission(
    String action,
    VerifyWideDataResponse data,
  ) async {
    if (action == 'WIPE_DATA') {
      await _performRemoteWipeIfRequested(data);
    }
  }
}
