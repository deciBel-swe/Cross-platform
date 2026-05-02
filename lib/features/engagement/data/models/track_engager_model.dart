import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/track_engager.dart';

part 'track_engager_model.freezed.dart';
part 'track_engager_model.g.dart';

@freezed
class TrackEngagerModel with _$TrackEngagerModel {
  const factory TrackEngagerModel({
    required int id,
    required String username,
    String? displayName,
    String? avatarUrl,
    required String tier,
    @Default(false) bool isFollowing,
  }) = _TrackEngagerModel;

  factory TrackEngagerModel.fromJson(Map<String, dynamic> json) =>
      _$TrackEngagerModelFromJson(json);
}

extension TrackEngagerModelX on TrackEngagerModel {
  TrackEngager toEntity() {
    return TrackEngager(
      id: id,
      username: username,
      displayName: displayName,
      avatarUrl: avatarUrl,
      tier: tier,
      isFollowing: isFollowing,
    );
  }
}
