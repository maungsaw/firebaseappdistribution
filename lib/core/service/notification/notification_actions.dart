import 'package:firebaseappdistribution/core/core.dart';
import 'package:flutter/foundation.dart';

Future<void> performRemoteWipeIfRequested(Map<String, dynamic> data) async {
  if (data['action'] != 'WIPE_DATA') return;

  debugPrint('Security alert: Remote wipe command detected!');
  await DatabaseFileService.cleanDatabase();
  await LocalCacheService.clearAll();
  await FileStorageService.removeFolders();
  debugPrint('Success: App-wide local data has been securely deleted.');
}

void handleNotificationNavigation(Map<String, dynamic> data) {
  final screen = data['screen'];
  if (screen == RouteName.calculator.path) {
    AppRouter.router.push(RouteName.calculator.path);
  }
}
