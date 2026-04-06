import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/paginated_tracks.dart';
import 'track_model.dart';

part 'paginated_tracks_model.freezed.dart';
part 'paginated_tracks_model.g.dart';

List<TrackModel> _trackListFromJson(List<dynamic>? json) {
  if (json == null) {
    return const <TrackModel>[];
  }

  return json
      .whereType<Map<String, dynamic>>()
      .map(TrackModel.fromJson)
      .toList();
}

List<Map<String, dynamic>> _trackListToJson(List<TrackModel> tracks) {
  return tracks.map((track) => track.toJson()).toList();
}

@freezed
class PaginatedTracksModel with _$PaginatedTracksModel {
  @JsonSerializable(explicitToJson: true)
  const factory PaginatedTracksModel({
    @JsonKey(fromJson: _trackListFromJson, toJson: _trackListToJson)
    @Default(<TrackModel>[])
    List<TrackModel> content,
    required int pageNumber,
    required int pageSize,
    required int totalElements,
    required int totalPages,
    required bool isLast,
  }) = _PaginatedTracksModel;

  factory PaginatedTracksModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedTracksModelFromJson(json);
}

extension PaginatedTracksModelX on PaginatedTracksModel {
  PaginatedTracks toEntity() {
    return PaginatedTracks(
      content: content.map((trackModel) => trackModel.toEntity()).toList(),
      pageNumber: pageNumber,
      pageSize: pageSize,
      totalElements: totalElements,
      totalPages: totalPages,
      isLast: isLast,
    );
  }
}
