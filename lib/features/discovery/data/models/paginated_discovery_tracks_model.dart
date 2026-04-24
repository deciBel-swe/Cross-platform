import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/paginated_discovery_tracks.dart';
import 'discovery_model_utils.dart';
import 'discovery_track_model.dart';

part 'paginated_discovery_tracks_model.freezed.dart';
part 'paginated_discovery_tracks_model.g.dart';

@freezed
class PaginatedDiscoveryTracksModel with _$PaginatedDiscoveryTracksModel {
  const factory PaginatedDiscoveryTracksModel({
    @Default(<DiscoveryTrackModel>[]) List<DiscoveryTrackModel> content,
    @Default(0) int pageNumber,
    @Default(0) int pageSize,
    @Default(0) int totalElements,
    @Default(0) int totalPages,
    @Default(true) bool isLast,
  }) = _PaginatedDiscoveryTracksModel;

  factory PaginatedDiscoveryTracksModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedDiscoveryTracksModelFromJson(_normalizePaginatedJson(json));

  factory PaginatedDiscoveryTracksModel.fromResponse(Object? response) {
    return PaginatedDiscoveryTracksModel.fromJson(asMapOrEmpty(response));
  }

  static Map<String, dynamic> _normalizePaginatedJson(
    Map<String, dynamic> json,
  ) {
    final payload = asMapOrEmpty(json);
    final content = asMapList(payload['content']);

    return <String, dynamic>{
      ...payload,
      'content': content,
      'pageNumber': asInt(payload['pageNumber']) ?? 0,
      'pageSize': asInt(payload['pageSize']) ?? content.length,
      'totalElements': asInt(payload['totalElements']) ?? content.length,
      'totalPages':
          asInt(payload['totalPages']) ?? (content.isEmpty ? 0 : 1),
      'isLast': asBool(payload['isLast'], fallback: true),
    };
  }
}

extension PaginatedDiscoveryTracksModelX on PaginatedDiscoveryTracksModel {
  PaginatedDiscoveryTracks toEntity() {
    return PaginatedDiscoveryTracks(
      content: content
          .map((DiscoveryTrackModel track) => track.toEntity())
          .toList(growable: false),
      pageNumber: pageNumber,
      pageSize: pageSize,
      totalElements: totalElements,
      totalPages: totalPages,
      isLast: isLast,
    );
  }
}
