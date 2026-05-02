// Secure storage wrapper (flutter_secure_storage) for tokens.

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/data/models/auth_user_model.dart';
import '../../features/auth/data/models/login_response_model.dart';

/// Service responsible for securely storing and retrieving authentication tokens.
///
/// Utilizes [FlutterSecureStorage] with encrypted shared preferences on Android
/// to ensure tokens are kept secure at rest.
@lazySingleton
class SecureStorageService {
  /// Constructs the service with the underlying storage mechanism.
  SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _expiryKey = 'token_expiry';
  static const String _userKey = 'auth_user';

  /// Saves the access token and calculates expiry time based on a successful
  /// login or OAuth exchange response.
  ///
  /// The [expiryTime] is derived from [LoginResponseModel.expiresIn] (seconds),
  /// as returned by the API.
  Future<void> saveTokenPair(LoginResponseModel response) async {
    final expiryTime = DateTime.now().add(
      Duration(seconds: response.expiresIn),
    );

    await _storage.write(key: _accessTokenKey, value: response.accessToken);
    await _storage.write(
      key: _expiryKey,
      value: expiryTime.millisecondsSinceEpoch.toString(),
    );
    await _storage.write(
      key: _userKey,
      value: jsonEncode(response.user.toJson()),
    );

    if (response.refreshToken != null && response.refreshToken!.isNotEmpty) {
      await _storage.write(key: _refreshTokenKey, value: response.refreshToken);
    }
  }

  /// Updates the cached user model in storage.
  Future<void> updateUser(AuthUserModel user) async {
    await _storage.write(
      key: _userKey,
      value: jsonEncode(user.toJson()),
    );
  }

  /// Saves newly refreshed access token and optionally updates the refresh token.
  ///
  /// Calculates the new expiry time based on [expiresIn] seconds retrieved
  /// from the server during a proactive or reactive refresh.
  Future<void> saveRefreshTokens({
    required String accessToken,
    String? refreshToken,
    required int expiresIn,
  }) async {
    final expiryTime = DateTime.now().add(Duration(seconds: expiresIn));

    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(
      key: _expiryKey,
      value: expiryTime.millisecondsSinceEpoch.toString(),
    );

    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  /// Retrieves the stored access token.
  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);

  /// Retrieves the stored refresh token.
  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  /// Retrieves the stored user model.
  Future<AuthUserModel?> getUser() async {
    final userStr = await _storage.read(key: _userKey);
    if (userStr == null) return null;
    try {
      final json = jsonDecode(userStr);
      return AuthUserModel.fromJson(json as Map<String, dynamic>);
    } catch (_) {
      return null; // Handle malformed data gracefully
    }
  }

  /// Checks if the access token is expired or within 1 minute of expiring.
  Future<bool> isAccessTokenExpired() async {
    final expiryStr = await _storage.read(key: _expiryKey);
    if (expiryStr == null) return true;

    final expiryMillis = int.tryParse(expiryStr);
    if (expiryMillis == null) return true;

    final expiryDate = DateTime.fromMillisecondsSinceEpoch(expiryMillis);

    // Consider token expired if current time is past expiry - 1 minute.
    final currentDate = DateTime.now();
    return currentDate.isAfter(expiryDate.subtract(const Duration(minutes: 1)));
  }

  /// Clears all stored secure keys, effectively wiping the session.
  Future<void> clearAll() => _storage.deleteAll();

  /// Generic string retrieval.
  Future<String?> getString(String key) => _storage.read(key: key);

  /// Generic string storage.
  Future<void> setString(String key, String value) =>
      _storage.write(key: key, value: value);

  /// Generic removal.
  Future<void> removeString(String key) => _storage.delete(key: key);
}
