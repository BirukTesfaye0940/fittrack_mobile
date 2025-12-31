import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _keyToken = 'auth_token';

  /// Save the JWT token after login/register
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  /// Retrieve token for API calls
  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  /// Delete token on Logout
  static Future<void> clearToken() async {
    await _storage.delete(key: _keyToken);
  }
}
