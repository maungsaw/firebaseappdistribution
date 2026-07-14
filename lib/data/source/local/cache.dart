import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalCacheService {
  static const _storage = FlutterSecureStorage(
    // Android: Enables hardware-backed encryption
    aOptions: AndroidOptions(resetOnError: true),
    // iOS: Standard Keychain access
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static Future<void> write(String key, String value) async =>
      await _storage.write(key: key, value: value);

  static Future<String?> read(String key) async =>
      await _storage.read(key: key);

  static Future<void> delete(String key) async =>
      await _storage.delete(key: key);

  static Future<void> clearAll() async => await _storage.deleteAll();
}
