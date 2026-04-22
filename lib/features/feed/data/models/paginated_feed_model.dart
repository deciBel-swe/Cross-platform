import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/paginated_feed.dart';
import 'feed_track_model.dart';

part 'paginated_feed_model.freezed.dart';
part 'paginated_feed_model.g.dart';

List<FeedTrackModel> _tracksFromJson(List<dynamic>? json) {
  if (json == null) return const <FeedTrackModel>[];
  return json
      .whereType<Map<String, dynamic>>()
      .map(FeedTrackModel.fromJson)
      .toList();
}

List<Map<String, dynamic>> _tracksToJson(List<FeedTrackModel> tracks) =>
    tracks.map((t) => t.toJson()).toList();

@freezed
class PaginatedFeedModel with _$PaginatedFeedModel {
  @JsonSerializable(explicitToJson: true)
  const factory PaginatedFeedModel({
    @JsonKey(fromJson: _tracksFromJson, toJson: _tracksToJson)
    @Default(<FeedTrackModel>[])
    List<FeedTrackModel> content,
    @Default(0) int pageNumber,
    @Default(0) int pageSize,
    @Default(0) int totalElements,
    @Default(0) int totalPages,
    @Default(true) bool isLast,
  }) = _PaginatedFeedModel;

  factory PaginatedFeedModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedFeedModelFromJson(json);
}

extension PaginatedFeedModelX on PaginatedFeedModel {
  PaginatedFeed toEntity() => PaginatedFeed(
    content: content.map((m) => m.toEntity()).toList(),
    pageNumber: pageNumber,
    pageSize: pageSize,
    totalElements: totalElements,
    totalPages: totalPages,
    isLast: isLast,
  );
}
