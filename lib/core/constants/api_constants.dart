class ApiConstants {
  ApiConstants._();

  //static const String baseUrl = 'https://decibel.foo/api';
  static const String baseUrl = 'https://decibel.foo/api';

  /// Step 1: Triggers Google login in browser
  static const String googleAuthEndpoint = '/oauth2/authorization/google';

  /// Step 2: Backend redirects browser -> returns Token
  /// Step 3: Flutter exchanges OAuth token with backend
  static const String googleTokenExchangeEndpoint = '/auth/oauth/google';

  // Dio Timeout constants
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Google OAuth specific constants
  static const String googleAuthUrl =
      'https://accounts.google.com/o/oauth2/v2/auth';
  static const String googleDesktopRedirectUri =
      'http://localhost:3000/login/oauth2/code/google';
  static const String googleMobileClientId =
      '767709617177-l61vbedk9lanvrgirt6e0840a4kijs6u.apps.googleusercontent.com';
  static const String googleDesktopClientId =
      '767709617177-ljng08734ds2qv9m7qcrpccpe6igu9if.apps.googleusercontent.com';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String resetPasswordEndpoint = '/auth/reset-password';
  static const String resendVerificationEndpoint =
      '/auth/resend-verification';
}
