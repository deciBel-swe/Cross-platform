/// Named route path constants.
class RoutePaths {
  RoutePaths._();

  static const String splash = '/';
  static const String start = '/start';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String feed = '/feed';
  static const String discover = '/discover';
  static const String search = '/search';
  static const String library = '/library';
  static const String settings = '/library/settings';
  static const String basicSettings = '/library/settings/basic-settings';
  static const String changeAppIcon =
      '/library/settings/basic-settings/change-app-icon';
  static const String socialSettings = '/library/settings/social-settings';
  static const String upgrade = '/upgrade';
  static const String player = '/player';
  static const String profile = '/profile';
  static const String profileFollowers = '/profile/followers';
  static const String profileFollowing = '/profile/following';
  static const String editProfile = '/profile/edit-profile';
  static const String upload = '/home/upload';
  static const String homeLikes = '/home/your-likes';
  static const String uploadLibrary = '/library/uploads';
  static const String libraryLikes = '/library/likes';
  static const String libraryReposts = '/library/reposts';
  static const String editWebLink = '/profile/edit-web-link';
  static const String trackPreviewBase = '/library/track-preview';
  static const String trackEditBase = '/library/track-edit';
  static const String playlists = '/library/playlists';
  static const String editPlaylist = '/library/playlists/edit';
  static const String playlistTracks = '/library/playlists/playlist-tracks';

  static String trackPreview(int trackId) => '$trackPreviewBase/$trackId';
  static String trackEdit(int trackId) => '$trackEditBase/$trackId';

  /// Public profile screen for viewing another user's profile.
  static const String publicProfileBase = '/user';
  static const String publicProfileFollowersBase = '/user-followers';
  static const String publicProfileFollowingBase = '/user-following';
  static String publicProfile(int userId) => '$publicProfileBase/$userId';
  static String publicProfileFollowers(int userId) =>
      '$publicProfileFollowersBase/$userId';
  static String publicProfileFollowing(int userId) =>
      '$publicProfileFollowingBase/$userId';
}
