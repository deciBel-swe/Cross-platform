import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/following_user.dart';

part 'following_user_model.freezed.dart';
part 'following_user_model.g.dart';

@freezed
class FollowingUserModel with _$FollowingUserModel {
  const factory FollowingUserModel({
    @JsonKey(fromJson: _toInt, defaultValue: 0) required int id,
    @JsonKey(defaultValue: '') required String username,
    String? avatarUrl,
    String? tier,
    @JsonKey(defaultValue: false) required bool isFollowing,
  }) = _FollowingUserModel;

  factory FollowingUserModel.fromJson(Map<String, dynamic> json) =>
      _$FollowingUserModelFromJson(json);
}

int _toInt(Object? value) => (value as num?)?.toInt() ?? 0;

extension FollowingUserModelMapper on FollowingUserModel {
  FollowingUser toEntity() {
    return FollowingUser(
      id: id,
      username: username,
      avatarUrl: avatarUrl,
      tier: tier,
      isFollowing: isFollowing,
    );
  }
}
