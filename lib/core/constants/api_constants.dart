class ApiConstants {
  ApiConstants._();

  //static const String baseUrl = 'http://192.168.1.4:3000/api';
  static const String baseUrl = 'http://192.168.1.4.nip.io:3000/api';

  /// Step 1: Triggers Google login in browser
  static const String googleAuthEndpoint = '/oauth2/authorization/google';

  /// Step 2: Backend redirects browser -> returns Token
  /// Step 3: Flutter exchanges OAuth token with backend
  static const String googleTokenExchangeEndpoint = '/auth/oauth/google';
}
