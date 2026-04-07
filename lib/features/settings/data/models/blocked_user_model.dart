import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/blocked_user.dart';

part 'blocked_user_model.freezed.dart';
part 'blocked_user_model.g.dart';

@freezed
class BlockedUserModel with _$BlockedUserModel {
  const factory BlockedUserModel({
    @JsonKey(fromJson: _toInt, defaultValue: 0) required int id,
    @JsonKey(defaultValue: '') required String username,
    String? avatarUrl,
    String? tier,
    @JsonKey(defaultValue: false) required bool isFollowing,
  }) = _BlockedUserModel;

  factory BlockedUserModel.fromJson(Map<String, dynamic> json) =>
      _$BlockedUserModelFromJson(json);
}

int _toInt(Object? value) => (value as num?)?.toInt() ?? 0;

extension BlockedUserModelMapper on BlockedUserModel {
  BlockedUser toEntity() {
    return BlockedUser(
      id: id,
      username: username,
      avatarUrl: avatarUrl,
      tier: tier,
      isFollowing: isFollowing,
    );
  }
}
