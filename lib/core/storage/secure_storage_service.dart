// Secure storage wrapper (flutter_secure_storage) for tokens.

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/data/models/login_response_model.dart';
import '../../features/auth/data/models/auth_user_model.dart';

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

  /// Saves the access token, refresh token, and calculates expiry time
  /// based on a successful login response.
  ///
  /// The [expiryTime] is currently hardcoded to 1 hour from the time of saving.
  Future<void> saveTokenPair(LoginResponseModel response) async {
    // will check with backend about token duration assume 1 hour for now
    final expiryTime = DateTime.now().add(const Duration(hours: 1));

    await Future.wait([
      _storage.write(key: _accessTokenKey, value: response.accessToken),
      _storage.write(key: _refreshTokenKey, value: response.refreshToken),
      _storage.write(
        key: _expiryKey,
        value: expiryTime.millisecondsSinceEpoch.toString(),
      ),
      _storage.write(
        key: _userKey,
        value: jsonEncode(response.user.toJson()),
      ),
    ]);
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

    final futures = <Future<void>>[
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(
        key: _expiryKey,
        value: expiryTime.millisecondsSinceEpoch.toString(),
      ),
    ];

    if (refreshToken != null) {
      futures.add(_storage.write(key: _refreshTokenKey, value: refreshToken));
    }

    await Future.wait(futures);
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
}
