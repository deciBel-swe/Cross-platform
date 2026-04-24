import '../../../library/domain/entities/track.dart';

/// Represents the user who created the playlist.
class PlaylistOwner {
  const PlaylistOwner({
    required this.id,
    required this.username,
    this.displayName,
    this.avatarUrl,
  });

  final int id;
  final String username;
  final String? displayName;
  final String? avatarUrl;
}

/// The core entity representing a saved Playlist.
class Playlist {
  const Playlist({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.isPrivate,
    required this.isLiked,
    this.coverArt,
    this.owner,
    required this.tracks,
    required this.totalDurationSeconds,
    required this.trackCount,
    this.playlistSlug,
    this.firstTrackWaveformUrl,
    this.secretToken,
    this.access,
    this.createdAt,
  });

  final int id;
  final String title;
  final String? description;
  final String type;
  final bool isPrivate;
  final bool isLiked;
  final String? coverArt;
  final PlaylistOwner? owner;
  final List<Track> tracks;
  final int totalDurationSeconds;
  final int trackCount;
  final String? playlistSlug;
  final String? firstTrackWaveformUrl;
  final String? secretToken;
  final String? access;
  final DateTime? createdAt;
}
