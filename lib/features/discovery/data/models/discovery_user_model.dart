import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/discovery_user.dart';
import 'discovery_model_utils.dart';

part 'discovery_user_model.freezed.dart';
part 'discovery_user_model.g.dart';

@freezed
class DiscoveryUserModel with _$DiscoveryUserModel {
  const factory DiscoveryUserModel({
    required int id,
    required String username,
    String? displayName,
    @Default(false) bool isFollowing,
    @Default(0) int followerCount,
    @Default(0) int trackCount,
    String? avatarUrl,
  }) = _DiscoveryUserModel;

  factory DiscoveryUserModel.fromJson(Map<String, dynamic> json) =>
      _$DiscoveryUserModelFromJson(_normalizeUserJson(json));

  static Map<String, dynamic> _normalizeUserJson(Map<String, dynamic> json) {
    return <String, dynamic>{
      ...json,
      'id': asInt(json['id']) ?? asInt(json['userId']) ?? 0,
      'username':
          asString(json['username']) ??
          asString(json['displayName']) ??
          'unknown-user',
      'displayName': asString(json['displayName']),
      'isFollowing': asBool(json['isFollowing']),
      'followerCount':
          asInt(json['followerCount']) ??
          asInt(json['followersCount']) ??
          0,
      'trackCount': asInt(json['trackCount']) ?? 0,
      'avatarUrl':
          asString(json['avatarUrl']) ?? asString(json['profilePic']),
    };
  }
}

extension DiscoveryUserModelX on DiscoveryUserModel {
  DiscoveryUser toEntity() {
    return DiscoveryUser(
      id: id,
      username: username,
      displayName: displayName,
      isFollowing: isFollowing,
      followerCount: followerCount,
      trackCount: trackCount,
      avatarUrl: avatarUrl,
    );
  }
}
