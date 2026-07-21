import 'package:firebaseappdistribution/core/function/detect_malware.dart';
import 'package:flutter/foundation.dart';

abstract class SecurityService {
  static Future<void> initializeSecurity() async {
    await MalWareSecurityService.instance.initializeSecurity(
      packageName: 'com.yourdomain.app',
      androidSigningHashes: ['YOUR_BASE64_SHA256_HASH_HERE='],
      iosBundleIds: ['com.yourdomain.app'],
      iosTeamId: 'YOUR_APPLE_TEAM_ID',
      watcherMail: 'security-alerts@yourdomain.com',
      isProd:
          kReleaseMode, // Automatically set true in production release builds
    );
  }
}
