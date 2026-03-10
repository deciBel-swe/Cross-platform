/// Mock fixtures for authentication data layer.
class AuthMockFixtures {
  AuthMockFixtures._();

  /// Mock network delay.
  static const Duration delay = Duration(milliseconds: 800);

  static const Map<String, dynamic> mockLoginResponse = {
    'accessToken': 'mock_access_token_12345',
    'refreshToken': 'mock_refresh_token_abcde',
    'user': {'id': 101, 'username': 'mock_user_free', 'tier': 'free'},
  };

  static const Map<String, dynamic> mockArtistLoginResponse = {
    'accessToken': 'mock_access_token_artist',
    'refreshToken': 'mock_refresh_token_artist',
    'user': {'id': 102, 'username': 'ziad_the_artist', 'tier': 'artist'},
  };

  static const Map<String, dynamic> mockRefreshResponse = {
    'accessToken': 'mock_access_token_refreshed',
    'refreshToken': 'mock_refresh_token_refreshed',
    'user': {'id': 101, 'username': 'mock_user_free', 'tier': 'free'},
  };
}
