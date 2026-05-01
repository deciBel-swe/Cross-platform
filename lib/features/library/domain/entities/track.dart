import 'artist.dart';
import 'track_status.dart';

class Track {
  const Track({
    required this.id,
    required this.title,
    required this.artist,
    this.trackUrl,
    this.coverUrl,
    this.waveformUrl,
    required this.genre,
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
  });

  final int id;
  final String title;
  final Artist artist;
  final String? trackUrl;
  final String? coverUrl;
  final String? waveformUrl;
  final String genre;
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

  Duration get duration => Duration(seconds: trackDurationSeconds);

  String? get normalizedTrackUrl {
    final value = trackUrl?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }
    return value;
  }

  bool get hasTrackUrl => normalizedTrackUrl != null;

  bool get isFailed => state == TrackStatus.failed;

  bool get isProcessing => state == TrackStatus.processing;

  bool get isPlayable => !isProcessing && !isFailed && hasTrackUrl;

  Track copyWith({
    int? id,
    String? title,
    Artist? artist,
    String? trackUrl,
    String? coverUrl,
    String? waveformUrl,
    String? genre,
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
  }) {
    return Track(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      trackUrl: trackUrl ?? this.trackUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      waveformUrl: waveformUrl ?? this.waveformUrl,
      genre: genre ?? this.genre,
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
    );
  }
}
