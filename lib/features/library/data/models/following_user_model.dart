import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/following_user.dart';

part 'following_user_model.freezed.dart';
part 'following_user_model.g.dart';

@freezed
class FollowingUserModel with _$FollowingUserModel {
  const factory FollowingUserModel({
    required int id,
    required String username,
    String? avatarUrl,
    String? tier,
    required bool isFollowing,
  }) = _FollowingUserModel;

  factory FollowingUserModel.fromJson(Map<String, dynamic> json) {
    return FollowingUserModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      username: (json['username'] ?? '') as String,
      avatarUrl: json['avatarUrl'] as String?,
      tier: json['tier'] as String?,
      isFollowing: (json['isFollowing'] as bool?) ?? false,
    );
  }
}

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
