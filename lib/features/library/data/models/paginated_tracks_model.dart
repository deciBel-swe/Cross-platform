import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/paginated_tracks.dart';
import 'track_model.dart';

part 'paginated_tracks_model.freezed.dart';
part 'paginated_tracks_model.g.dart';

@freezed
class PaginatedTracksModel with _$PaginatedTracksModel {
  const factory PaginatedTracksModel({
    @Default(<TrackModel>[]) List<TrackModel> content,
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
