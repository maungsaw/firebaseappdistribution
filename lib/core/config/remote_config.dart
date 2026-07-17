import 'dart:async';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebaseappdistribution/core/core.dart';
import 'package:flutter/material.dart';

class MaintenanceWrapper extends StatefulWidget {
  final Widget child;
  const MaintenanceWrapper({super.key, required this.child});

  @override
  State<MaintenanceWrapper> createState() => _MaintenanceWrapperState();
}

class _MaintenanceWrapperState extends State<MaintenanceWrapper>
    with WidgetsBindingObserver {
  bool _isDialogShowing = false;
  late StreamSubscription _configSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _configureRemoteConfig();
    _configSubscription = FirebaseRemoteConfig.instance.onConfigUpdated.listen((
      event,
    ) async {
      await FirebaseRemoteConfig.instance.activate();
      _checkMaintenance();
    });

    // 4. Initial check
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkMaintenance());
  }

  Future<void> _configureRemoteConfig() async {
    await FirebaseRemoteConfig.instance.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero, // Use Duration.zero for testing
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FirebaseRemoteConfig.instance.fetchAndActivate().then((_) {
        _checkMaintenance();
      });
    }
  }

  void _checkMaintenance() {
    final isMaintenance = FirebaseRemoteConfig.instance.getBool(
      'is_maintenance_mode',
    );
    final context = RootNavigation.rootKey.currentContext;

    if (context == null) return;

    if (isMaintenance && !_isDialogShowing) {
      _showMaintenanceDialog(context);
    } else if (!isMaintenance && _isDialogShowing) {
      // Auto-dismiss if maintenance is turned off
      Navigator.of(context).pop();
      _isDialogShowing = false;
    }
  }

  void _showMaintenanceDialog(BuildContext context) {
    _isDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text("System Maintenance"),
          content: Text(
            "We are currently under maintenance. Please try again later.",
          ),
        ),
      ),
    ).then((_) {
      _isDialogShowing = false;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _configSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
