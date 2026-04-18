import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  static String _requiredEnv(String key) {
    if (!dotenv.isInitialized) {
      throw StateError(
        'Missing required environment variable (dotenv uninitialized): $key',
      );
    }
    final value = dotenv.env[key]?.trim();
    if (value == null || value.isEmpty) {
      throw StateError('Missing required environment variable: $key');
    }
    return value;
  }

  static const String _defaultBaseUrl = 'https://decibel.foo/api';

  static String get baseUrl {
    if (!dotenv.isInitialized) return _defaultBaseUrl;
    final envBaseUrl = dotenv.env['API_BASE_URL']?.trim();
    if (envBaseUrl == null || envBaseUrl.isEmpty) {
      return _defaultBaseUrl;
    }
    return envBaseUrl;
  }

  static void validate() {
    // Trigger getters that use _requiredEnv to catch missing keys early
    _requiredEnv('GOOGLE_MOBILE_CLIENT_ID');
    // Add other critical keys here
    debugPrint("✅ Environment variables validated.");
  }

  /// Endpoint for patching the current user's profile
  static const String updateProfile = '/users/me';

  /// Endpoint for patching the current user's social links
  /// Note: this doesn't work now we are using patch /users/me with full profile payload, but keeping it here for reference in case we want to split social links into a separate endpoint in the future
  static const String updateSocialLinks = '/users/me/social-links';

  /// Step 1: Triggers Google login in browser
  static const String googleAuthEndpoint = '/oauth2/authorization/google';

  /// Step 2: Backend redirects browser -> returns Token
  /// Step 3: Flutter exchanges OAuth token with backend
  static const String googleTokenExchangeEndpoint = '/auth/oauth/google';
  static const String localLoginEndpoint = '/auth/login/local';
  static const String localRegisterEndpoint = '/auth/register/local';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshTokenEndpoint = '/auth/refreshtoken';
  static const String genresEndpoint = '/genres';

  static const String subscriptionCancelEndpoint = '/subscription/cancel';
  static const String subscriptionCheckoutEndpoint = '/subscription/checkout';
  static const String subscriptionRenewEndpoint = '/subscription/renew';
  static const String subscriptionStatusEndpoint = '/subscription/status';

  static const String userProfileEndpoint = '/users/me';
  static const String userProfilePrivacy = '/users/me/privacy';
  static const String userProfileImage = '/users/me/images';

  /// Fetches a public user profile by identifier.
  ///
  /// - Numeric value => GET /users/{id}
  /// - Non-numeric value => GET /users/username/{username}
  static String publicProfile(Object identifier) {
    final normalized = identifier.toString().trim();
    final userId = int.tryParse(normalized);
    if (userId != null) {
      return '/users/$userId';
    }
    return publicProfileByUsername(normalized);
  }

  /// Fetches a public user profile by username: GET /users/username/{username}
  static String publicProfileByUsername(String username) =>
      '/users/username/${Uri.encodeComponent(username)}';

  /// Resolves a track slug into an internal numeric track ID.
  static String resolveTrackBySlug(String slug) => '/tracks/resolve/$slug';

  /// Follows or unfollows a user: POST|DELETE /users/{userId}/follow
  static String followUser(int userId) => '/users/$userId/follow';

  /// Base endpoint for playlist operations
  static const String playlists = '/playlists';

  /// Endpoint to get the current authenticated user's playlists
  static const String myPlaylists = '/users/me/playlists';

  /// Endpoint for operations on a specific playlist for the current user
  static String myPlaylist(int id) => '/users/me/playlists/$id';

  /// Endpoint to get playlists created by a specific user ID
  static String userPublicPlaylists(int userId) => '/users/$userId/playlists';

  /// Endpoint for liked playlists
  static const String likedPlaylists = '/users/me/playlists/liked';

  /// Endpoint for playlist's tracks reordering
  static String updateTracksOrder(int playlistId) =>
      '/playlists/$playlistId/tracks/reorder';

  // Endpoint for getting the playlist secret link
  static String getPlaylistSecretLink(int playlistId) =>
      '${ApiConstants.playlists}/$playlistId/secret-link';
  // Dio Timeout constants
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  static const String tracks = '/tracks';
  static const String comments = '/comments';
  static const String replies = '/replies';

  static const String notificationSettingsEndpoint = '/notifications/settings';
static const String notificationDeviceTokensEndpoint =
    '/notifications/device-tokens';
  // Google OAuth specific constants
  static const String googleAuthUrl =
      'https://accounts.google.com/o/oauth2/v2/auth';
  static const String googleDesktopRedirectUri = 'http://localhost:8081';

  static String get googleMobileClientId =>
      _requiredEnv('GOOGLE_MOBILE_CLIENT_ID');
  static String get googleDesktopClientId {
    if (!dotenv.isInitialized) {
      throw StateError(
        'Missing required environment variable (dotenv uninitialized)',
      );
    }
    final desktop = dotenv.env['GOOGLE_DESKTOP_CLIENT_ID']?.trim();
    if (desktop != null && desktop.isNotEmpty) {
      return desktop;
    }

    final legacyWeb = dotenv.env['GOOGLE_WEB_CLIENT_ID']?.trim();
    if (legacyWeb != null && legacyWeb.isNotEmpty) {
      return legacyWeb;
    }

    throw StateError(
      'Missing required environment variable: GOOGLE_DESKTOP_CLIENT_ID (or GOOGLE_WEB_CLIENT_ID)',
    );
  }

  static String get recaptchaSiteKey {
    if (!dotenv.isInitialized) {
      return '6Ldh3posAAAAAM8gLEEHLzIOcxEwGDyfiwSYn940';
    }
    final value = dotenv.env['RECAPTCHA_SITE_KEY']?.trim();
    if (value == null || value.isEmpty) {
      return '6Ldh3posAAAAAM8gLEEHLzIOcxEwGDyfiwSYn940';
    }
    return value;
  }
}
