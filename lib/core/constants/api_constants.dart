import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  static String _requiredEnv(String key) {
    final value = dotenv.env[key]?.trim();
    if (value == null || value.isEmpty) {
      throw StateError('Missing required environment variable: $key');
    }
    return value;
  }

  static const String _defaultBaseUrl = 'https://decibel.foo/api';

  static String get baseUrl {
    final envBaseUrl = dotenv.env['API_BASE_URL']?.trim();
    if (envBaseUrl == null || envBaseUrl.isEmpty) {
      return _defaultBaseUrl;
    }
    return envBaseUrl;
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
  static const String logoutEndpoint = '/auth/logout';
  static const String genresEndpoint = '/genres';

  static const String userProfileEndpoint = '/users/me';
  static const String userProfilePrivacy = '/users/me/privacy';
  static const String userProfileImage = '/users/me/images';

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

  // Google OAuth specific constants
  static const String googleAuthUrl =
      'https://accounts.google.com/o/oauth2/v2/auth';
  static const String googleDesktopRedirectUri = 'http://localhost:8081';

  static String get googleMobileClientId =>
      _requiredEnv('GOOGLE_MOBILE_CLIENT_ID');
  static String get googleDesktopClientId =>
      _requiredEnv('GOOGLE_DESKTOP_CLIENT_ID');
}
