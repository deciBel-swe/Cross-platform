class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://localhost:8082/api';
  //static const String baseUrl = 'http://127.0.0.1:8081/api';
  //static const String baseUrl = 'http://10.0.2.2:8081';
  // static const String baseUrl =
  //     'https://30d05557-562b-4dbd-ab42-3c3725b209ea.mock.pstmn.io';
  //static const String baseUrl = 'http://192.168.1.4:3000/api';

  /// Endpoint for patching the current user's profile
  static const String updateProfile = '/users/me';

  /// Endpoint for patching the current user's social links
  static const String updateSocialLinks = '/users/me/social-links';

  /// Step 1: Triggers Google login in browser
  static const String googleAuthEndpoint = '/oauth2/authorization/google';

  /// Step 2: Backend redirects browser -> returns Token
  /// Step 3: Flutter exchanges OAuth token with backend
  static const String googleTokenExchangeEndpoint = '/auth/oauth/google';
  static const String logoutEndpoint = '/auth/logout';

  static const String userProfileEndpoint = '/users/me';
  static const String userProfilePrivacy = '/users/me/privacy';

  // Dio Timeout constants
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Google OAuth specific constants
  static const String googleAuthUrl =
      'https://accounts.google.com/o/oauth2/v2/auth';
  static const String googleDesktopRedirectUri = 'http://localhost:8081';
  static const String googleMobileClientId =
      '767709617177-l61vbedk9lanvrgirt6e0840a4kijs6u.apps.googleusercontent.com';

  static const String googleDesktopClientId =
      '767709617177-ljng08734ds2qv9m7qcrpccpe6igu9if.apps.googleusercontent.com';
}
