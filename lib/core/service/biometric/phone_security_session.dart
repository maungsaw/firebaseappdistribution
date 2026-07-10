import 'package:flutter/foundation.dart';

import 'device_auth_service.dart';
import 'phone_security_capabilities.dart';

/// Keeps phone-security verification for the current app session.
/// After one successful verify, protected screens open without re-prompting
/// until the app process is closed.
class PhoneSecuritySession extends ChangeNotifier {
  PhoneSecuritySession._();

  static final PhoneSecuritySession instance = PhoneSecuritySession._();

  bool _isVerified = false;
  DateTime? _verifiedAt;
  PhoneSecurityCapabilities? _capabilities;
  bool _isLoadingCapabilities = false;

  bool get isVerified => _isVerified;
  DateTime? get verifiedAt => _verifiedAt;
  PhoneSecurityCapabilities? get capabilities => _capabilities;
  bool get isLoadingCapabilities => _isLoadingCapabilities;

  Future<void> ensureCapabilitiesLoaded() async {
    if (_capabilities != null || _isLoadingCapabilities) return;

    _isLoadingCapabilities = true;
    notifyListeners();

    _capabilities = await DeviceAuthService.getCapabilities();

    _isLoadingCapabilities = false;
    notifyListeners();
  }

  Future<void> refreshCapabilities() async {
    _capabilities = null;
    await ensureCapabilitiesLoaded();
  }

  void markVerified() {
    _isVerified = true;
    _verifiedAt = DateTime.now();
    notifyListeners();
  }

  void lock() {
    if (!_isVerified) return;
    _isVerified = false;
    _verifiedAt = null;
    notifyListeners();
  }
}
