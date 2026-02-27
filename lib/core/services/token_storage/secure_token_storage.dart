import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'token_storage.dart';

/// Implementation of [TokenStorage] using [FlutterSecureStorage].
final class SecureTokenStorage implements TokenStorage {
  final FlutterSecureStorage _secureStorage;

  static const _accessTokenKey = 'access_token';

  /// Creates an instance of [SecureTokenStorage].
  SecureTokenStorage(this._secureStorage);

  @override
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  @override
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
  }

  @override
  Future<void> deleteAccessToken() async {
    await _secureStorage.delete(key: _accessTokenKey);
  }

  @override
  Future<bool> hasAccessToken() {
    return _secureStorage.containsKey(key: _accessTokenKey);
  }
}
