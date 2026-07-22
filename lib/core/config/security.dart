import 'package:firebaseappdistribution/core/function/detect_malware.dart';

abstract class SecurityService {
  static Future<void> initializeSecurity() async {
    await MalWareSecurityService.instance.initializeSecurity(
      packageName: 'com.sawhtunaung.firebaseappdistribution',
      androidSigningHashes: ['Gy7b7dzhC0mqmQGzj44er8+kOaJRxuki4+n4we8yyEM='],
      iosBundleIds: ['com.sawhtunaung.firebaseappdistribution'],
      iosTeamId: 'YOUR_APPLE_TEAM_ID',
      watcherMail: 'security-alerts@yourdomain.com',
      isProd: true, // Automatically set true in production release
    );
  }
}
