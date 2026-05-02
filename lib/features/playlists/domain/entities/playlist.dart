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
    this.isReposted = false,
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
  final bool isReposted;
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

  Playlist copyWith({
    int? id,
    String? title,
    String? description,
    String? type,
    bool? isPrivate,
    bool? isLiked,
    bool? isReposted,
    String? coverArt,
    PlaylistOwner? owner,
    List<Track>? tracks,
    int? totalDurationSeconds,
    int? trackCount,
    String? playlistSlug,
    String? firstTrackWaveformUrl,
    String? secretToken,
    String? access,
    DateTime? createdAt,
  }) {
    return Playlist(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      isPrivate: isPrivate ?? this.isPrivate,
      isLiked: isLiked ?? this.isLiked,
      isReposted: isReposted ?? this.isReposted,
      coverArt: coverArt ?? this.coverArt,
      owner: owner ?? this.owner,
      tracks: tracks ?? this.tracks,
      totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
      trackCount: trackCount ?? this.trackCount,
      playlistSlug: playlistSlug ?? this.playlistSlug,
      firstTrackWaveformUrl:
          firstTrackWaveformUrl ?? this.firstTrackWaveformUrl,
      secretToken: secretToken ?? this.secretToken,
      access: access ?? this.access,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
