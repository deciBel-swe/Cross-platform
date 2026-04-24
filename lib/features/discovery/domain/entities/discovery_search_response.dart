import 'discovery_playlist.dart';
import 'discovery_track.dart';
import 'discovery_user.dart';

/// Search response split into users, tracks, and playlists.
class DiscoverySearchResponse {
  const DiscoverySearchResponse({
    this.users = const <DiscoveryUser>[],
    this.tracks = const <DiscoveryTrack>[],
    this.playlists = const <DiscoveryPlaylist>[],
    this.pageNumber = 0,
    this.pageSize = 0,
    this.totalElements = 0,
    this.totalPages = 0,
    this.isLast = true,
  });

  final List<DiscoveryUser> users;
  final List<DiscoveryTrack> tracks;
  final List<DiscoveryPlaylist> playlists;
  final int pageNumber;
  final int pageSize;
  final int totalElements;
  final int totalPages;
  final bool isLast;
}
