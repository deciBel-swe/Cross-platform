import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/discovery_search_response.dart';
import 'discovery_model_utils.dart';
import 'discovery_playlist_model.dart';
import 'discovery_track_model.dart';
import 'discovery_user_model.dart';

part 'discovery_search_response_model.freezed.dart';
part 'discovery_search_response_model.g.dart';

@freezed
class DiscoverySearchResponseModel with _$DiscoverySearchResponseModel {
  const factory DiscoverySearchResponseModel({
    @Default(<DiscoveryUserModel>[]) List<DiscoveryUserModel> users,
    @Default(<DiscoveryTrackModel>[]) List<DiscoveryTrackModel> tracks,
    @Default(<DiscoveryPlaylistModel>[]) List<DiscoveryPlaylistModel> playlists,
    @Default(0) int pageNumber,
    @Default(0) int pageSize,
    @Default(0) int totalElements,
    @Default(0) int totalPages,
    @Default(true) bool isLast,
  }) = _DiscoverySearchResponseModel;

  factory DiscoverySearchResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DiscoverySearchResponseModelFromJson(_normalizeSearchJson(json));

  factory DiscoverySearchResponseModel.fromResponse(Object? response) {
    return DiscoverySearchResponseModel.fromJson(asMapOrEmpty(response));
  }

  static Map<String, dynamic> _normalizeSearchJson(Map<String, dynamic> json) {
    final payload = asMapOrEmpty(json);
    final users = <Map<String, dynamic>>[];
    final tracks = <Map<String, dynamic>>[];
    final playlists = <Map<String, dynamic>>[];
    final content = asMapList(payload['content']);

    for (final Map<String, dynamic> item in content) {
      _appendContentItem(
        item: item,
        users: users,
        tracks: tracks,
        playlists: playlists,
      );
    }

    if (content.isEmpty && asString(payload['resourceType']) != null) {
      _appendContentItem(
        item: payload,
        users: users,
        tracks: tracks,
        playlists: playlists,
      );
    }

    final totalElements =
        asInt(payload['totalElements']) ??
        users.length + tracks.length + playlists.length;

    return <String, dynamic>{
      'users': users,
      'tracks': tracks,
      'playlists': playlists,
      'pageNumber': asInt(payload['pageNumber']) ?? 0,
      'pageSize': asInt(payload['pageSize']) ?? totalElements,
      'totalElements': totalElements,
      'totalPages': asInt(payload['totalPages']) ?? (totalElements == 0 ? 0 : 1),
      'isLast': asBool(payload['isLast'], fallback: true),
    };
  }

  static void _appendContentItem({
    required Map<String, dynamic> item,
    required List<Map<String, dynamic>> users,
    required List<Map<String, dynamic>> tracks,
    required List<Map<String, dynamic>> playlists,
  }) {
    final resourceType =
        asString(item['resourceType'] ?? item['type'])?.toUpperCase();

    switch (resourceType) {
      case 'USER':
        users.add(
          asMapOrEmpty(item['user']).isNotEmpty
              ? asMapOrEmpty(item['user'])
              : <String, dynamic>{
                  ...item,
                  'id': asInt(item['resourceId']) ?? asInt(item['id']) ?? 0,
                },
        );
        break;
      case 'TRACK':
        tracks.add(
          asMapOrEmpty(item['track']).isNotEmpty
              ? asMapOrEmpty(item['track'])
              : <String, dynamic>{
                  ...item,
                  'id': asInt(item['resourceId']) ?? asInt(item['id']) ?? 0,
                },
        );
        break;
      case 'PLAYLIST':
        playlists.add(
          asMapOrEmpty(item['playlist']).isNotEmpty
              ? asMapOrEmpty(item['playlist'])
              : <String, dynamic>{
                  ...item,
                  'id': asInt(item['resourceId']) ?? asInt(item['id']) ?? 0,
                },
        );
        break;
      case null:
        break;
    }
  }
}

extension DiscoverySearchResponseModelX on DiscoverySearchResponseModel {
  DiscoverySearchResponse toEntity() {
    return DiscoverySearchResponse(
      users: users
          .map((DiscoveryUserModel user) => user.toEntity())
          .toList(growable: false),
      tracks: tracks
          .map((DiscoveryTrackModel track) => track.toEntity())
          .toList(growable: false),
      playlists: playlists
          .map((DiscoveryPlaylistModel playlist) => playlist.toEntity())
          .toList(growable: false),
      pageNumber: pageNumber,
      pageSize: pageSize,
      totalElements: totalElements,
      totalPages: totalPages,
      isLast: isLast,
    );
  }
}
