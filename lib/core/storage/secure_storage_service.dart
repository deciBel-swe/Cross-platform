// Secure storage wrapper (flutter_secure_storage) for tokens.

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/data/models/login_response_model.dart';

@lazySingleton
class SecureStorageService {
  SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _expiryKey = 'token_expiry';

  /// Saves the access token, refresh token, and calculates expiry time.
  Future<void> saveTokenPair(LoginResponseModel response) async {
    final expiryTime = DateTime.now().add(const Duration(hours: 1));

    await Future.wait([
      _storage.write(key: _accessTokenKey, value: response.accessToken),
      _storage.write(key: _refreshTokenKey, value: response.refreshToken),
      _storage.write(
        key: _expiryKey,
        value: expiryTime.millisecondsSinceEpoch.toString(),
      ),
    ]);
  }

  /// Saves raw access and refresh tokens without requiring a user model.
  Future<void> saveRawTokenPair({
    required String accessToken,
    required String refreshToken,
  }) async {
    final expiryTime = DateTime.now().add(const Duration(hours: 1));

    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
      _storage.write(
        key: _expiryKey,
        value: expiryTime.millisecondsSinceEpoch.toString(),
      ),
    ]);
  }

  /// Retrieves the stored access token.
  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);

  /// Retrieves the stored refresh token.
  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  /// Checks if the access token is expired
  Future<bool> isAccessTokenExpired() async {
    final expiryStr = await _storage.read(key: _expiryKey);
    if (expiryStr == null) return true;

    final expiryMillis = int.tryParse(expiryStr);
    if (expiryMillis == null) return true;

    final expiryDate = DateTime.fromMillisecondsSinceEpoch(expiryMillis);

    final currentDate = DateTime.now();
    return currentDate.isAfter(expiryDate.subtract(const Duration(minutes: 1)));
  }

  /// Clears all stored secure keys.
  Future<void> clearAll() => _storage.deleteAll();
}