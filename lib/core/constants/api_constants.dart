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
  static const String globalSearchEndpoint = '/search';
  static const String trendingTracksEndpoint = '/explore/trending';
  static const String resendVerificationEndpoint = '/auth/resend-verification';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String resetPasswordEndpoint = '/auth/reset-password';

  /// Station endpoints are relative to the `/api` base URL.
  static const String genreStationEndpoint = '/stations/genre';
  static const String artistStationEndpoint = '/stations/artist';
  static const String likesStationEndpoint = '/stations/likes';

  static const String subscriptionCancelEndpoint = '/subscription/cancel';
  static const String subscriptionCheckoutEndpoint = '/subscription/checkout';
  static const String subscriptionRenewEndpoint = '/subscription/renew';
  static const String subscriptionStatusEndpoint = '/subscription/status';

  static const String userProfileEndpoint = '/users/me';
  static const String userProfilePrivacy = '/users/me/privacy';
  static const String userProfileImage = '/users/me/images';
  static const String listeningHistory = '/users/me/history';

  /// Base endpoint for upload operations
  static const String uploads = '/uploads';

  /// Upload-specific socket endpoint
  static const String uploadProgress = '$uploads/progress';
  static const String trackUploadV2 = '/tracks/upload/v2';
  static const Duration trackUploadRequestTimeout = Duration(minutes: 5);

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

  /// WebSocket Base URL (Converts http -> ws, and https -> wss)
  static String get wsBaseUrl {
    if (baseUrl.startsWith('https')) {
      return baseUrl.replaceFirst('https', 'wss');
    } else if (baseUrl.startsWith('http')) {
      return baseUrl.replaceFirst('http', 'ws');
    }
    return baseUrl;
  }

  /// Upload Progress WebSocket Topic
  static String trackUploadStatusTopic(String uploadId) =>
      '/topic/track-status/$uploadId';

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

  /// Endpoint to get public playlists created by a specific username.
  static String userPublicPlaylistsByUsername(String username) =>
      '/users/${Uri.encodeComponent(username)}/playlists';

  /// Endpoint for tracks liked by a public user.
  static String likedTracksByUsername(String username) =>
      '/users/${Uri.encodeComponent(username)}/liked-tracks';

  /// Endpoint for tracks reposted by a public user.
  static String repostedTracksByUsername(String username) =>
      '/users/${Uri.encodeComponent(username)}/reposted-tracks';

  /// Endpoint for playlists liked by a public user.
  static String likedPlaylistsByUsername(String username) =>
      '/users/${Uri.encodeComponent(username)}/liked-playlists';

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

  /// Endpoint for recording a track play start.
  static String trackPlay(int trackId) => '/tracks/$trackId/play';

  /// Endpoint for recording a completed listen.
  static String trackComplete(int trackId) => '/tracks/$trackId/complete';

  // --- Notifications ---
  static const String notifications = '/notifications';
  static const String unreadNotificationCount = '/notifications/unread-count';
  static const String markAllNotificationsRead = '/notifications/mark-all-read';
  static const String deviceTokens = '/notifications/device-tokens';

  static const String notificationSettingsEndpoint = '/notifications/settings';

  // ==========================================
  // MESSAGING ENDPOINTS
  // ==========================================

  /// Base endpoint for direct messages conversations
  static const String conversations = '/conversations';

  /// Endpoint to get messages for a specific conversation
  static String conversationMessages(String id) =>
      '/conversations/$id/messages';

  /// Endpoint to start a new conversation with a user
  static String startConversation(int id) => '/conversations/$id/start';
  // Google OAuth specific constants
  static const String googleAuthUrl =
      'https://accounts.google.com/o/oauth2/v2/auth';
  static const String googleDesktopRedirectUri =
      'http://localhost:8081/oauth/callback';

  static String get googleMobileClientId =>
      _requiredEnv('GOOGLE_MOBILE_CLIENT_ID');

  /// Web OAuth client used by Google to mint server auth codes that the
  /// backend can exchange with Google's token endpoint.
  static String get googleServerClientId {
    if (!dotenv.isInitialized) {
      throw StateError(
        'Missing required environment variable (dotenv uninitialized)',
      );
    }
    final web = dotenv.env['GOOGLE_WEB_CLIENT_ID']?.trim();
    if (web != null && web.isNotEmpty) {
      return web;
    }

    throw StateError(
      'Missing required environment variable: GOOGLE_WEB_CLIENT_ID',
    );
  }

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
