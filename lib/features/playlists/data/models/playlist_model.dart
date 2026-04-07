import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../library/data/models/track_model.dart';

part 'playlist_model.freezed.dart';
part 'playlist_model.g.dart';

@freezed
class OwnerModel with _$OwnerModel {
  const factory OwnerModel({required int id, required String username}) =
      _OwnerModel;

  factory OwnerModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerModelFromJson(json);
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
    @JsonKey(name: 'CoverArt') String? coverArt,
    OwnerModel? owner,
    @Default([]) List<TrackModel> tracks,
  }) = _PlaylistModel;

  factory PlaylistModel.fromJson(Map<String, dynamic> json) =>
      _$PlaylistModelFromJson(json);
}
