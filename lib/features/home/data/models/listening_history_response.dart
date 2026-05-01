import '../../../library/domain/entities/artist.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library/domain/entities/track_status.dart';
import '../../domain/entities/listening_history_page.dart';

/// Response model for `GET /users/me/history`.
class ListeningHistoryResponse {
  const ListeningHistoryResponse({
    required this.content,
    required this.pageNumber,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
    required this.isLast,
  });

  factory ListeningHistoryResponse.fromJson(Map<String, dynamic> json) {
    final content = json['content'];
    final tracks = content is List<dynamic>
        ? <Track>[
            for (final item in content) _trackFromJson(_asStringMap(item)),
          ]
        : const <Track>[];

    return ListeningHistoryResponse(
      content: tracks,
      pageNumber: _asInt(json['pageNumber']),
      pageSize: _asInt(json['pageSize']),
      totalElements: _asInt(json['totalElements']),
      totalPages: _asInt(json['totalPages']),
      isLast: _asBool(json['isLast']),
    );
  }

  final List<Track> content;
  final int pageNumber;
  final int pageSize;
  final int totalElements;
  final int totalPages;
  final bool isLast;

  ListeningHistoryPage toEntity() {
    return ListeningHistoryPage(
      content: content,
      pageNumber: pageNumber,
      pageSize: pageSize,
      totalElements: totalElements,
      totalPages: totalPages,
      isLast: isLast,
    );
  }

  static Track _trackFromJson(Map<String, dynamic> json) {
    final artistJson = _asStringMap(json['artist']);
    final access = _asString(json['access']).toUpperCase();
    final now = DateTime.now();


    final releaseDate =
        DateTime.tryParse(_asString(json['releaseDate'])) ??
        DateTime.tryParse(_asString(json['createdAt'])) ??
        now;

    return Track(
      id: _asInt(json['id']),
      title: _asString(json['title']),
      artist: Artist(
        id: _asInt(artistJson['id']),
        username: _asString(artistJson['username']),
        displayName: _asNullableString(artistJson['displayName']),
        avatarUrl: _asNullableString(artistJson['avatarUrl']),
      ),
      trackUrl: _asNullableString(json['trackUrl']),
      trackPreviewUrl: _asNullableString(json['trackPreviewUrl']),
      coverUrl: _asNullableString(json['coverUrl']),
      waveformUrl: null,
      genre: '',
      access: access,
      tags: const [],
      state: _parseTrackStatus(access),
      releaseDate: releaseDate,
      playCount: _asInt(json['playCount']),
      likeCount: _asInt(json['likeCount']),
      repostCount: _asInt(json['repostCount']),
      isLiked: _asBool(json['isLiked']),
      isReposted: _asBool(json['isReposted']),
      createdAt: releaseDate,
      trackDurationSeconds: _asInt(json['trackDurationSeconds']),
      isPrivate: _asBool(json['isPrivate']) || _asBool(json['is_private']),
    );
  }

  static TrackStatus _parseTrackStatus(String access) {
    return access == 'BLOCKED' ? TrackStatus.failed : TrackStatus.finished;
  }

  static Map<String, dynamic> _asStringMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map<Object?, Object?>) {
      return Map<String, dynamic>.from(value);
    }
    return const <String, dynamic>{};
  }

  static String _asString(Object? value) {
    return value?.toString().trim() ?? '';
  }

  static String? _asNullableString(Object? value) {
    final text = _asString(value);
    return text.isEmpty ? null : text;
  }

  static int _asInt(Object? value) {
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value.trim()) ?? 0;
    }
    return 0;
  }

  static bool _asBool(Object? value) {
    if (value is bool) {
      return value;
    }
    if (value is String) {
      return value.trim().toLowerCase() == 'true';
    }
    return false;
  }


}
