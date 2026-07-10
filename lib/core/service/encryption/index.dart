import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class KeyManager {
  static const _storage = FlutterSecureStorage();
  static const _keyName = 'column_encryption_key';

  static Future<encrypt.Key> getEncryptionKey() async {
    String? base64Key = await _storage.read(key: _keyName);

    if (base64Key == null) {
      final newKey = encrypt.Key.fromSecureRandom(32);
      await _storage.write(key: _keyName, value: newKey.base64);
      return newKey;
    }

    return encrypt.Key.fromBase64(base64Key);
  }
}
