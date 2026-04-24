import 'discovery_user.dart';

/// Lightweight playlist entity for search and discovery surfaces.
class DiscoveryPlaylist {
  const DiscoveryPlaylist({
    required this.id,
    required this.title,
    required this.owner,
    this.type = 'PLAYLIST',
    this.isLiked = false,
    this.description,
    this.isPrivate = false,
    this.coverArtUrl,
    this.playlistSlug,
    this.totalDurationSeconds = 0,
    this.trackCount = 0,
    this.genres = const <String>[],
    this.createdAt,
  });

  final int id;
  final String title;
  final DiscoveryUser owner;
  final String type;
  final bool isLiked;
  final String? description;
  final bool isPrivate;
  final String? coverArtUrl;
  final String? playlistSlug;
  final int totalDurationSeconds;
  final int trackCount;
  final List<String> genres;
  final DateTime? createdAt;
}
