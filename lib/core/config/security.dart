import 'dart:io';

import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/core/function/detect_malware.dart';
import 'package:flutter/material.dart';

abstract class SecurityService {
  static Future<void> initializeSecurity() async {
    await MalWareSecurityService.instance.initializeSecurity(
      packageName: 'com.sawhtunaung.firebaseappdistribution',
      androidSigningHashes: ['Gy7b7dzhC0mqmQGzj44er8+kOaJRxuki4+n4we8yyEM='],
      iosBundleIds: ['com.sawhtunaung.firebaseappdistribution'],
      iosTeamId: 'YOUR_APPLE_TEAM_ID',
      watcherMail: 'security-alerts@yourdomain.com',
      isProd: true,
    );
  }

  static void onThreatDetected(String? threatType) {
    debugPrint('THREAD TYPE => $threatType');

    final context = AppRoot.rootKey.currentContext;
    debugPrint("Current context -> $context");
    if (context == null) {
      exit(0);
    }

    // Show persistent threat popup
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) {
        return PopScope(
          canPop: false, // Prevent physical back button on Android
          child: AlertDialog(
            title: const Text('Security Risk Detected'),
            content: Text(
              'A security threat ($threatType) was detected on this device. The application will close.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  exit(0);
                },
                child: const Text('Exit App'),
              ),
            ],
          ),
        );
      },
    );
  }
}
