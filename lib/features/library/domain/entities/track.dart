import 'artist.dart';
import 'track_status.dart';

class Track {
  const Track({
    required this.id,
    required this.title,
    required this.artist,
    this.trackUrl,
    this.trackPreviewUrl,
    this.coverUrl,
    this.waveformUrl,
    required this.genre,
    this.access = 'PLAYABLE',
    required this.tags,
    required this.state,
    required this.releaseDate,
    required this.playCount,
    required this.likeCount,
    required this.repostCount,
    required this.isLiked,
    required this.isReposted,
    required this.createdAt,
    this.description,
    required this.trackDurationSeconds,
    this.isPrivate = false,
  });

  final int id;
  final String title;
  final Artist artist;
  final String? trackUrl;
  final String? trackPreviewUrl;
  final String? coverUrl;
  final String? waveformUrl;
  final String genre;
  final String access;
  final List<String> tags;
  final TrackStatus state;
  final DateTime releaseDate;
  final int playCount;
  final int likeCount;
  final int repostCount;
  final bool isLiked;
  final bool isReposted;
  final DateTime createdAt;
  final String? description;
  final int trackDurationSeconds;
  final bool isPrivate;

  Duration get duration => Duration(seconds: trackDurationSeconds);

  String? get normalizedTrackUrl {
    final fullUrl = trackUrl?.trim();
    if (fullUrl != null && fullUrl.isNotEmpty) {
      return fullUrl;
    }
    final previewUrl = trackPreviewUrl?.trim();
    if (previewUrl != null && previewUrl.isNotEmpty) {
      return previewUrl;
    }
    return null;
  }

  bool get hasTrackUrl => normalizedTrackUrl != null;

  bool get isFailed => state == TrackStatus.failed;

  bool get isProcessing => state == TrackStatus.processing;

  bool get isPlayable => !isProcessing && !isFailed && (hasTrackUrl || trackPreviewUrl != null);

  bool get isBlocked => access.toUpperCase() == 'BLOCKED';
  bool get isPreviewOnly => access.toUpperCase() == 'PREVIEW';

  Track copyWith({
    int? id,
    String? title,
    Artist? artist,
    String? trackUrl,
    String? trackPreviewUrl,
    String? coverUrl,
    String? waveformUrl,
    String? genre,
    String? access,
    List<String>? tags,
    TrackStatus? state,
    DateTime? releaseDate,
    int? playCount,
    int? likeCount,
    int? repostCount,
    bool? isLiked,
    bool? isReposted,
    DateTime? createdAt,
    String? description,
    int? trackDurationSeconds,
    bool? isPrivate,
  }) {
    return Track(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      trackUrl: trackUrl ?? this.trackUrl,
      trackPreviewUrl: trackPreviewUrl ?? this.trackPreviewUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      waveformUrl: waveformUrl ?? this.waveformUrl,
      genre: genre ?? this.genre,
      access: access ?? this.access,
      tags: tags ?? this.tags,
      state: state ?? this.state,
      releaseDate: releaseDate ?? this.releaseDate,
      playCount: playCount ?? this.playCount,
      likeCount: likeCount ?? this.likeCount,
      repostCount: repostCount ?? this.repostCount,
      isLiked: isLiked ?? this.isLiked,
      isReposted: isReposted ?? this.isReposted,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      trackDurationSeconds: trackDurationSeconds ?? this.trackDurationSeconds,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }
}
