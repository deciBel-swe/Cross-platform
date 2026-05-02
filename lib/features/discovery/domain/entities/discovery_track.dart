import 'discovery_user.dart';

/// Shared discovery-track entity used by search, trending, and stations.
class DiscoveryTrack {
  const DiscoveryTrack({
    required this.id,
    required this.title,
    required this.artist,
    this.slug,
    this.trackUrl,
    this.trackPreviewUrl,
    this.coverUrl,
    this.waveformUrl,
    this.genre,
    this.tags = const <String>[],
    this.availability,
    this.isLiked = false,
    this.isReposted = false,
    this.playCount = 0,
    this.likeCount = 0,
    this.repostCount = 0,
    this.commentCount = 0,
    this.releaseDate,
    this.createdAt,
    this.description,
    this.secretToken,
  });

  final int id;
  final String title;
  final DiscoveryUser artist;
  final String? slug;
  final String? trackUrl;
  final String? trackPreviewUrl;
  final String? coverUrl;
  final String? waveformUrl;
  final String? genre;
  final List<String> tags;
  final String? availability;
  final bool isLiked;
  final bool isReposted;
  final int playCount;
  final int likeCount;
  final int repostCount;
  final int commentCount;
  final DateTime? releaseDate;
  final DateTime? createdAt;
  final String? description;
  final String? secretToken;
}
