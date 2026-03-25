import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

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

  // Dio Timeout constants
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Google OAuth specific constants
  static const String googleAuthUrl =
      'https://accounts.google.com/o/oauth2/v2/auth';
  static const String googleDesktopRedirectUri = 'http://localhost:8081';
  // devops requested this change ana msh mas2ol
  // static const String googleDesktopRedirectUri =
  //     'https://decibel.foo/oauth/callback';

  // static const String googleMobileClientId =
  //     '767709617177-l61vbedk9lanvrgirt6e0840a4kijs6u.apps.googleusercontent.com';
  static const String googleMobileClientId =
      '32707752970-iogrei2270q4qni8eicn9r8osb1006mr.apps.googleusercontent.com';
  // static const String googleDesktopClientId =
  //       '767709617177-ljng08734ds2qv9m7qcrpccpe6igu9if.apps.googleusercontent.com';
  static const String googleDesktopClientId =
      '32707752970-h86ssrpl5a1vt717qfop1n5080hpqu6l.apps.googleusercontent.com';
}
