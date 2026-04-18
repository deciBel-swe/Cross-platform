import '../../../library/domain/entities/artist.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library/domain/entities/track_status.dart';

class ListeningHistoryResponse {
  ListeningHistoryResponse({
    required this.content,
    required this.pageNumber,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
    required this.isLast,
  });

  final List<Track> content;
  final int pageNumber;
  final int pageSize;
  final int totalElements;
  final int totalPages;
  final bool isLast;

  static Track _trackFromJson(Map<String, dynamic> json) {
    final artistJson = (json['artist'] as Map<String, dynamic>? ?? {});

    final createdAt =
        DateTime.tryParse(json['createdAt'] as String? ?? '') ??
        DateTime.now();

    return Track(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      artist: Artist(
        id: (artistJson['id'] as num?)?.toInt() ?? 0,
        username: artistJson['username'] as String? ?? '',
        displayName: artistJson['displayName'] as String?,
        avatarUrl: null,
      ),
      trackUrl: json['trackUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
      waveformUrl: null,
      genre: '',
      tags: const [],
      state: _parseTrackStatus(json['access']),
      releaseDate: createdAt,
      playCount: (json['playCount'] as num?)?.toInt() ?? 0,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      repostCount: (json['repostCount'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      isReposted: json['isReposted'] as bool? ?? false,
      createdAt: createdAt,
    );
  }

  static TrackStatus _parseTrackStatus(Object? raw) {
    final value = (raw as String? ?? '').toUpperCase();

    switch (value) {
      case 'PROCESSING':
        return TrackStatus.processing;
      default:
        return TrackStatus.finished;
    }
  }

  factory ListeningHistoryResponse.fromJson(Map<String, dynamic> json) {
    return ListeningHistoryResponse(
      content: (json['content'] as List<dynamic>? ?? [])
          .map((item) => _trackFromJson(item as Map<String, dynamic>))
          .toList(),
      pageNumber: (json['pageNumber'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      totalElements: (json['totalElements'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      isLast: json['isLast'] as bool? ?? false,
    );
  }
}