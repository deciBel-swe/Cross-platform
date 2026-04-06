import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/blocked_user.dart';

part 'blocked_user_model.freezed.dart';
part 'blocked_user_model.g.dart';

@freezed
class BlockedUserModel with _$BlockedUserModel {
  const factory BlockedUserModel({
    required int id,
    required String username,
    String? avatarUrl,
    String? tier,
    required bool isFollowing,
  }) = _BlockedUserModel;

  factory BlockedUserModel.fromJson(Map<String, dynamic> json) =>
      _$BlockedUserModelFromJson(json);
}

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