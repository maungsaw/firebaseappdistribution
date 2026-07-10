import 'package:flutter/material.dart';

enum PhoneAuthMethod {
  none,
  fingerprint,
  face,
  pinPassword,
}

class PhoneSecurityCapabilities {
  final bool canUseSecurity;
  final String methodLabel;
  final PhoneAuthMethod primaryMethod;

  const PhoneSecurityCapabilities({
    required this.canUseSecurity,
    required this.methodLabel,
    required this.primaryMethod,
  });

  static const loading = PhoneSecurityCapabilities(
    canUseSecurity: false,
    methodLabel: 'Checking...',
    primaryMethod: PhoneAuthMethod.none,
  );

  IconData get icon {
    return switch (primaryMethod) {
      PhoneAuthMethod.fingerprint => Icons.fingerprint_rounded,
      PhoneAuthMethod.face => Icons.face_rounded,
      PhoneAuthMethod.pinPassword => Icons.pin_rounded,
      PhoneAuthMethod.none => Icons.security_rounded,
    };
  }

  String get shortStatusLabel {
    if (!canUseSecurity) return 'Not configured';
    return switch (primaryMethod) {
      PhoneAuthMethod.fingerprint => 'Fingerprint',
      PhoneAuthMethod.face => 'Face unlock',
      PhoneAuthMethod.pinPassword => 'PIN / Password',
      PhoneAuthMethod.none => 'Phone security',
    };
  }
}
