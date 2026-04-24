import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/discovery_track.dart';
import 'discovery_model_utils.dart';
import 'discovery_user_model.dart';

part 'discovery_track_model.freezed.dart';
part 'discovery_track_model.g.dart';

@freezed
class DiscoveryTrackModel with _$DiscoveryTrackModel {
  const factory DiscoveryTrackModel({
    required int id,
    required String title,
    required DiscoveryUserModel artist,
    String? slug,
    String? trackUrl,
    String? trackPreviewUrl,
    String? coverUrl,
    String? waveformUrl,
    String? genre,
    @Default(<String>[]) List<String> tags,
    String? availability,
    @Default(false) bool isLiked,
    @Default(false) bool isReposted,
    @Default(0) int playCount,
    @Default(0) int likeCount,
    @Default(0) int repostCount,
    @Default(0) int commentCount,
    DateTime? releaseDate,
    DateTime? createdAt,
    int? durationSeconds,
    String? description,
    String? secretToken,
  }) = _DiscoveryTrackModel;

  factory DiscoveryTrackModel.fromJson(Map<String, dynamic> json) =>
      _$DiscoveryTrackModelFromJson(_normalizeTrackJson(json));

  static Map<String, dynamic> _normalizeTrackJson(Map<String, dynamic> json) {
    final artistPayload =
        asMapOrEmpty(json['artist']).isNotEmpty
            ? asMapOrEmpty(json['artist'])
            : asMapOrEmpty(json['user']).isNotEmpty
            ? asMapOrEmpty(json['user'])
            : asMapOrEmpty(json['actor']);

    return <String, dynamic>{
      ...json,
      'id': asInt(json['id']) ?? asInt(json['resourceId']) ?? 0,
      'title': asString(json['title']) ?? 'Untitled track',
      'artist': DiscoveryUserModel.fromJson(
        artistPayload.isEmpty
            ? const <String, dynamic>{'id': 0, 'username': 'unknown-artist'}
            : artistPayload,
      ).toJson(),
      'slug': asString(json['slug']) ?? asString(json['trackSlug']),
      'trackUrl': asString(json['trackUrl']),
      'trackPreviewUrl': asString(json['trackPreviewUrl']),
      'coverUrl': asString(json['coverUrl']),
      'waveformUrl': asString(json['waveformUrl']),
      'genre': asString(json['genre']),
      'tags': asStringList(json['tags']),
      'availability': asString(json['access']) ?? asString(json['state']),
      'isLiked': asBool(json['isLiked']),
      'isReposted': asBool(json['isReposted']),
      'playCount': asInt(json['playCount']) ?? 0,
      'likeCount': asInt(json['likeCount']) ?? 0,
      'repostCount': asInt(json['repostCount']) ?? 0,
      'commentCount': asInt(json['commentCount']) ?? 0,
      'releaseDate': asDateTime(json['releaseDate'])?.toIso8601String(),
      'createdAt': asDateTime(json['createdAt'] ?? json['uploadDate'])
          ?.toIso8601String(),
      'durationSeconds': asInt(json['trackDurationSeconds']),
      'description': asString(json['description']),
      'secretToken': asString(json['secretToken']),
    };
  }
}

extension DiscoveryTrackModelX on DiscoveryTrackModel {
  DiscoveryTrack toEntity() {
    return DiscoveryTrack(
      id: id,
      title: title,
      artist: artist.toEntity(),
      slug: slug,
      trackUrl: trackUrl,
      trackPreviewUrl: trackPreviewUrl,
      coverUrl: coverUrl,
      waveformUrl: waveformUrl,
      genre: genre,
      tags: tags,
      availability: availability,
      isLiked: isLiked,
      isReposted: isReposted,
      playCount: playCount,
      likeCount: likeCount,
      repostCount: repostCount,
      commentCount: commentCount,
      releaseDate: releaseDate,
      createdAt: createdAt,
      durationSeconds: durationSeconds,
      description: description,
      secretToken: secretToken,
    );
  }
}
