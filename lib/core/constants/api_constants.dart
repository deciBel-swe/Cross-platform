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
  static const String localLoginEndpoint = '/auth/login/local';
  static const String localRegisterEndpoint = '/auth/register/local';
  static const String logoutEndpoint = '/auth/logout';
  static const String genresEndpoint = '/genres';

  static const String userProfileEndpoint = '/users/me';
  static const String userProfilePrivacy = '/users/me/privacy';
  static const String userProfileImage = '/users/me/images';

  // Dio Timeout constants
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Google OAuth specific constants
  static const String googleAuthUrl =
      'https://accounts.google.com/o/oauth2/v2/auth';
  static const String googleDesktopRedirectUri = 'http://localhost:8081';

  static String get googleMobileClientId =>
      _requiredEnv('GOOGLE_MOBILE_CLIENT_ID');
  static String get googleDesktopClientId {
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
    final value = dotenv.env['RECAPTCHA_SITE_KEY']?.trim();
    if (value == null || value.isEmpty) {
      return '6Ldh3posAAAAAM8gLEEHLzIOcxEwGDyfiwSYn940';
    }
    return value;
  }
}
