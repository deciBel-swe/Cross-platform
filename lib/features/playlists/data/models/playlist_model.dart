import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../library/data/models/track_model.dart';

part 'playlist_model.freezed.dart';
part 'playlist_model.g.dart';

@freezed
class OwnerModel with _$OwnerModel {
  const factory OwnerModel({
    @JsonKey(name: 'userId') required int id,
    required String username,
    String? displayName,
    String? avatarUrl,
  }) = _OwnerModel;

  factory OwnerModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerModelFromJson(json);
}

class PlaylistTracksConverter
    implements JsonConverter<List<TrackModel>, dynamic> {
  const PlaylistTracksConverter();

  @override
  List<TrackModel> fromJson(Object? json) {
    if (json == null) return [];

    List<dynamic> list = [];
    if (json is Map) {
      if (json.containsKey('content')) {
        list = json['content'] as List<dynamic>? ?? [];
      }
    } else if (json is List) {
      list = json;
    }

    return list
        .where((e) => e != null)
        .map((e) => TrackModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  dynamic toJson(List<TrackModel> object) =>
      object.map((e) => e.toJson()).toList();
}

@freezed
class PlaylistModel with _$PlaylistModel {
  const factory PlaylistModel({
    required int id,
    required String title,
    String? description,
    required String type,
    @Default(false) bool isPrivate,
    @Default(false) bool isLiked,
    @JsonKey(name: 'coverArtUrl') String? coverArt,
    OwnerModel? owner,
    @PlaylistTracksConverter() @Default([]) List<TrackModel> tracks,
    @Default(0) int totalDurationSeconds,
    @Default(0) int trackCount,
  }) = _PlaylistModel;

  factory PlaylistModel.fromJson(Map<String, dynamic> json) =>
      _$PlaylistModelFromJson(json);
}
