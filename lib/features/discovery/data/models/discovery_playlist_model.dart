import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/discovery_playlist.dart';
import 'discovery_model_utils.dart';
import 'discovery_user_model.dart';

part 'discovery_playlist_model.freezed.dart';
part 'discovery_playlist_model.g.dart';

@freezed
class DiscoveryPlaylistModel with _$DiscoveryPlaylistModel {
  const factory DiscoveryPlaylistModel({
    required int id,
    required String title,
    required DiscoveryUserModel owner,
    @Default('PLAYLIST') String type,
    @Default(false) bool isLiked,
    String? description,
    @Default(false) bool isPrivate,
    String? coverArtUrl,
    String? playlistSlug,
    @Default(0) int totalDurationSeconds,
    @Default(0) int trackCount,
    @Default(<String>[]) List<String> genres,
    DateTime? createdAt,
  }) = _DiscoveryPlaylistModel;

  factory DiscoveryPlaylistModel.fromJson(Map<String, dynamic> json) =>
      _$DiscoveryPlaylistModelFromJson(_normalizePlaylistJson(json));

  static Map<String, dynamic> _normalizePlaylistJson(
    Map<String, dynamic> json,
  ) {
    final ownerPayload =
        asMapOrEmpty(json['owner']).isNotEmpty
            ? asMapOrEmpty(json['owner'])
            : asMapOrEmpty(json['user']);

    return <String, dynamic>{
      ...json,
      'id': asInt(json['id']) ?? asInt(json['resourceId']) ?? 0,
      'title': asString(json['title']) ?? 'Untitled playlist',
      'owner': DiscoveryUserModel.fromJson(
        ownerPayload.isEmpty
            ? const <String, dynamic>{'id': 0, 'username': 'unknown-user'}
            : ownerPayload,
      ).toJson(),
      'type': asString(json['type']) ?? 'PLAYLIST',
      'isLiked': asBool(json['isLiked']),
      'description': asString(json['description']),
      'isPrivate': asBool(json['isPrivate']),
      'coverArtUrl':
          asString(json['coverArtUrl']) ?? asString(json['coverUrl']),
      'playlistSlug': asString(json['playlistSlug']),
      'totalDurationSeconds': asInt(json['totalDurationSeconds']) ?? 0,
      'trackCount': asInt(json['trackCount']) ?? 0,
      'genres': asStringList(json['genres']),
      'createdAt': asDateTime(json['createdAt'])?.toIso8601String(),
    };
  }
}

extension DiscoveryPlaylistModelX on DiscoveryPlaylistModel {
  DiscoveryPlaylist toEntity() {
    return DiscoveryPlaylist(
      id: id,
      title: title,
      owner: owner.toEntity(),
      type: type,
      isLiked: isLiked,
      description: description,
      isPrivate: isPrivate,
      coverArtUrl: coverArtUrl,
      playlistSlug: playlistSlug,
      totalDurationSeconds: totalDurationSeconds,
      trackCount: trackCount,
      genres: genres,
      createdAt: createdAt,
    );
  }
}
