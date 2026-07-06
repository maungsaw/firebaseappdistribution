import 'dart:isolate';
import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

// This function runs in a separate Isolate
@pragma('vm:entry-point')
void startCallback() {
  debugPrint("Next Strart");
  FlutterForegroundTask.setTaskHandler(ForegroundTaskHandler());
}

@pragma('vm:entry-point')
class ForegroundTaskHandler extends TaskHandler {
  // Flag to prevent overlapping sync operations
  bool _isSyncing = false;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter taskStarter) async {
    debugPrint("Service started.");
  }

  @override
  void onRepeatEvent(DateTime timestamp) async {
    // 1. Check if already syncing
    if (_isSyncing) return;

    // 2. Check enabled status
    String? enabled = await LocalCacheService.read('sync_enabled');
    if (enabled != 'true') return;

    // 3. Perform Sync with guard
    await performApiSync();
  }

  Future<void> performApiSync() async {
    _isSyncing = true;
    try {
      debugPrint('Executing API Sync...');
      final TestService service = TestService();
      for (int i = 1; i < 30; i++) {
        await service.syncTask('Name-MS -$i');
      }

      // Mark as finished in cache
      await LocalCacheService.write('sync_enabled', 'false');
      debugPrint('Sync completed successfully.');
    } catch (e) {
      debugPrint('Sync Error: $e');
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    // Used for one-off triggered events
    await runSyncAndStop();
  }

  Future<void> runSyncAndStop() async {
    await performApiSync();
    debugPrint("Sync complete, stopping foreground service.");
    await FlutterForegroundTask.stopService();
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    debugPrint("Service destroyed.");
    _isSyncing = false;
    // No error throwing here to ensure smooth shutdown
  }
}
