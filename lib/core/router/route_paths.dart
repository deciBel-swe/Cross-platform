/// Named route path constants.
class RoutePaths {
  RoutePaths._();

  static const Set<String> reservedDeepLinkSegments = <String>{
    'start',
    'login',
    'register',
    'home',
    'feed',
    'discover',
    'search',
    'library',
    'upgrade',
    'profile',
    'user',
    'profile-image',
    'resend-verification',
    'playlist',
  };
  // ==========================================
  // MESSAGING ROUTES
  // ==========================================

  static const String chat = '/chat';
  static const String messages = '/messages';
  static const String newMessage = '/messages/new';

  static const String splash = '/';
  static const String start = '/start';
  static const String login = '/login';
  static const String register = '/register';
  static const String resendVerification = '/resend-verification';
  static const String home = '/home';
  static const String feed = '/feed';
  static const String discover = '/discover';
  static const String search = '/search';
  static const String library = '/library';
  static const String libraryFollowing = '/library/following';
  static const String settings = '/library/settings';
  static const String basicSettings = '/library/settings/basic-settings';
  static const String changeAppIcon =
      '/library/settings/basic-settings/change-app-icon';
  static const String socialSettings = '/library/settings/social-settings';
  static const String blockedUsers =
      '/library/settings/social-settings/blocked';
  static const String notificationSettings = '/library/settings/notifications';
  static const String upgrade = '/upgrade';
  static const String player = '/player';
  static const String profile = '/profile';
  static const String profileFollowers = '/profile/followers';
  static const String profileFollowing = '/profile/following';
  static const String editProfile = '/profile/edit-profile';
  static const String upload = '/home/upload';
  static const String homeLikes = '/home/your-likes';
  static const String homePopularCollection = '/home/collections/popular';
  static const String homeLikesStation = '/home/stations/likes';
  static const String homeArtistStation = '/home/stations/artist';
  static const String homeGenreStation = '/home/stations/genre';
  static const String uploadLibrary = '/library/uploads';
  static const String libraryDownloads = '/library/downloads';
  static const String libraryLikes = '/library/likes';
  static const String libraryReposts = '/library/reposts';
  static const String editWebLink = '/profile/edit-web-link';
  static const String trackPreviewBase = '/library/track-preview';
  static const String trackEditBase = '/library/track-edit';
  static const String playlists = '/library/playlists';
  static const String createPlaylist = '/library/playlists/create';
  static const String editPlaylist = '/library/playlists/edit';
  static const String playlistTracks = '/library/playlists/playlist-tracks';
  static const String addToPlaylist = '/library/add-to-playlist';
  static const String notifications = '/notifications';
  static const String recentlyPlayed = '/library/recently-played';

  static String trackPreview(int trackId) => '$trackPreviewBase/$trackId';
  static String trackEdit(int trackId) => '$trackEditBase/$trackId';

  /// Public profile screen for viewing another user's profile.
  static const String publicProfileBase = '/user';
  static const String publicProfileFollowersBase = '/followers';
  static const String publicProfileFollowingBase = '/following';

  static String publicProfile(String userIdentifier) {
    final encodedIdentifier = _encodeUserIdentifier(userIdentifier);
    if (encodedIdentifier.isEmpty) {
      return home;
    }

    return '$publicProfileBase/$encodedIdentifier';
  }

  static String publicProfileFollowers(String userIdentifier) {
    final encodedIdentifier = _encodeUserIdentifier(userIdentifier);
    if (encodedIdentifier.isEmpty) {
      return home;
    }

    return '$publicProfileBase/$encodedIdentifier$publicProfileFollowersBase';
  }

  static String publicProfileFollowing(String userIdentifier) {
    final encodedIdentifier = _encodeUserIdentifier(userIdentifier);
    if (encodedIdentifier.isEmpty) {
      return home;
    }

    return '$publicProfileBase/$encodedIdentifier$publicProfileFollowingBase';
  }

  static String deepLinkPlaylist(String username, String playlistIdentifier) =>
      '/$username/playlist/$playlistIdentifier';

  static String deepLinkSecretPlaylist(String token) =>
      '/playlist/secret/$token';

  static String deepLinkProfile(String username) => '/$username';

  static String deepLinkTrack(String username, String trackIdentifier) =>
      '/$username/$trackIdentifier';

  static bool isReservedDeepLinkSegment(String value) {
    return reservedDeepLinkSegments.contains(value.toLowerCase());
  }

  static String _encodeUserIdentifier(String userIdentifier) {
    final normalized = userIdentifier.trim();
    if (normalized.isEmpty) {
      return '';
    }
    return Uri.encodeComponent(normalized);
  }

  static const String forgotPassword = '/login-create-account/forgot-password';
  static const String resetPassword = '/reset-password';
}
