import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/auth_user.dart';

part 'auth_user_model.freezed.dart';
part 'auth_user_model.g.dart';

@freezed
class AuthUserModel with _$AuthUserModel {
  const factory AuthUserModel({
    required int id,
    required String username,
    required String tier,
    String? profileUrl,
    String? avatarUrl,
  }) = _AuthUserModel;

  const AuthUserModel._();

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);

  AuthUser toDomain() {
    return AuthUser(
      id: id,
      username: username,
      tier: _parseTier(tier),
      profileUrl: profileUrl,
      avatarUrl: avatarUrl,
    );
  }

  UserTier _parseTier(String tierString) {
    switch (tierString) {
      case 'ARTIST':
        return UserTier.artist;
      case 'ARTIST_PRO':
        return UserTier.artistPro;
      case 'FREE':
      default:
        return UserTier.free;
    }
  }
}
