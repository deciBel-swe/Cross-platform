/// Supported search filters for the discovery search experience.
enum DiscoverySearchType {
  all('ALL', 'All'),
  users('USER', 'People'),
  tracks('TRACK', 'Tracks'),
  playlists('PLAYLIST', 'Playlists');

  const DiscoverySearchType(this.queryValue, this.label);

  final String queryValue;
  final String label;

  static DiscoverySearchType fromQueryValue(String? rawValue) {
    final normalized = rawValue?.trim().toUpperCase();

    return switch (normalized) {
      'USER' || 'USERS' => DiscoverySearchType.users,
      'TRACK' || 'TRACKS' => DiscoverySearchType.tracks,
      'PLAYLIST' || 'PLAYLISTS' => DiscoverySearchType.playlists,
      _ => DiscoverySearchType.all,
    };
  }
}
