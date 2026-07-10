import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

import 'device_credential_auth.dart';
import 'phone_security_capabilities.dart';

class DeviceAuthResult {
  final bool success;
  final String? errorCode;
  final String? errorMessage;

  const DeviceAuthResult({
    required this.success,
    this.errorCode,
    this.errorMessage,
  });

  String get userMessage {
    if (success) return 'Phone security verified';

    switch (errorCode) {
      case 'NotAvailable':
        return 'Phone security is not available on this device.';
      case 'NotEnrolled':
        return 'Set up fingerprint, face unlock, or screen lock in phone settings.';
      case 'LockedOut':
      case 'PermanentlyLockedOut':
        return 'Too many attempts. Try again later from phone lock settings.';
      case 'PasscodeNotSet':
        return 'No screen lock found. Enable PIN/password in phone settings.';
      case 'auth_in_progress':
        return 'Authentication is already in progress.';
      case 'cancelled':
        return 'Authentication cancelled.';
      default:
        return errorMessage ?? 'Authentication cancelled.';
    }
  }
}

class DeviceAuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> isDeviceSupported() => _auth.isDeviceSupported();

  static Future<bool> canCheckBiometrics() async => _auth.canCheckBiometrics;

  static Future<List<BiometricType>> getAvailableBiometrics() =>
      _auth.getAvailableBiometrics();

  /// True when the phone has screen lock and/or biometrics usable for auth.
  static Future<bool> canUsePhoneSecurity() async {
    if (Platform.isAndroid) {
      final keyguardSecure = await DeviceCredentialAuth.isDeviceSecure();
      if (keyguardSecure) return true;
    }
    return isDeviceSupported();
  }

  static Future<bool> isDeviceSecured() => canUsePhoneSecurity();

  static Future<String> getAuthMethodLabel() async {
    return (await getCapabilities()).methodLabel;
  }

  static Future<PhoneSecurityCapabilities> getCapabilities() async {
    final canUse = await canUsePhoneSecurity();
    final types = await getAvailableBiometrics();
    final labels = <String>[];

    if (types.contains(BiometricType.fingerprint)) {
      labels.add('Fingerprint');
    }
    if (types.contains(BiometricType.face)) {
      labels.add('Face unlock');
    }
    if (types.contains(BiometricType.strong) ||
        types.contains(BiometricType.weak)) {
      labels.add('Biometric');
    }

    PhoneAuthMethod primary = PhoneAuthMethod.none;
    if (types.contains(BiometricType.fingerprint)) {
      primary = PhoneAuthMethod.fingerprint;
    } else if (types.contains(BiometricType.face)) {
      primary = PhoneAuthMethod.face;
    } else if (canUse) {
      primary = PhoneAuthMethod.pinPassword;
    }

    if (labels.isNotEmpty) {
      labels.add('Phone PIN / Password');
      return PhoneSecurityCapabilities(
        canUseSecurity: canUse,
        methodLabel: labels.join(', '),
        primaryMethod: primary,
      );
    }

    if (canUse) {
      return const PhoneSecurityCapabilities(
        canUseSecurity: true,
        methodLabel: 'Phone PIN / Password',
        primaryMethod: PhoneAuthMethod.pinPassword,
      );
    }

    return const PhoneSecurityCapabilities(
      canUseSecurity: false,
      methodLabel: 'Not configured',
      primaryMethod: PhoneAuthMethod.none,
    );
  }

  /// Uses phone settings: fingerprint, face, PIN, pattern, or password.
  static Future<DeviceAuthResult> authenticate({
    String reason = 'Use your phone security to continue',
  }) async {
    if (Platform.isAndroid) {
      return _authenticateOnAndroid(reason);
    }

    if (!await isDeviceSupported()) {
      return const DeviceAuthResult(
        success: false,
        errorCode: 'NotAvailable',
        errorMessage: 'Device authentication is not supported.',
      );
    }

    return _authenticateWithLocalAuth(reason);
  }

  static Future<DeviceAuthResult> _authenticateOnAndroid(String reason) async {
    final keyguardSecure = await DeviceCredentialAuth.isDeviceSecure();
    if (!keyguardSecure && !await isDeviceSupported()) {
      return const DeviceAuthResult(
        success: false,
        errorCode: 'PasscodeNotSet',
        errorMessage: 'No screen lock found on this device.',
      );
    }

    if (await isDeviceSupported()) {
      final localResult = await _authenticateWithLocalAuth(reason);
      if (localResult.success) return localResult;

      final cancelled = localResult.errorCode == 'cancelled' ||
          localResult.userMessage == 'Authentication cancelled.';
      if (cancelled) return localResult;
    }

    if (keyguardSecure) {
      return DeviceCredentialAuth.authenticate(
        title: 'Phone Security Required',
        description: reason,
      );
    }

    return const DeviceAuthResult(
      success: false,
      errorCode: 'NotAvailable',
      errorMessage: 'Device authentication is not supported.',
    );
  }

  static Future<DeviceAuthResult> _authenticateWithLocalAuth(String reason) async {
    try {
      final success = await _auth.authenticate(
        localizedReason: reason,
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Phone Security Required',
            biometricHint: 'Touch fingerprint sensor',
            cancelButton: 'Cancel',
            goToSettingsButton: 'Settings',
            goToSettingsDescription:
                'Please set up fingerprint, face unlock, or screen lock.',
            deviceCredentialsRequiredTitle: 'Phone lock required',
            deviceCredentialsSetupDescription:
                'Enable screen lock in your phone settings.',
          ),
        ],
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
          sensitiveTransaction: true,
        ),
      );

      if (success) {
        return const DeviceAuthResult(success: true);
      }

      return const DeviceAuthResult(
        success: false,
        errorCode: 'cancelled',
      );
    } on PlatformException catch (e) {
      debugPrint('DeviceAuthService error: ${e.code} ${e.message}');
      return DeviceAuthResult(
        success: false,
        errorCode: e.code,
        errorMessage: e.message,
      );
    }
  }
}
