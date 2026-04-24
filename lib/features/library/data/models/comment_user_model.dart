import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/comment_user.dart';

part 'comment_user_model.freezed.dart';
part 'comment_user_model.g.dart';

@freezed
class CommentUserModel with _$CommentUserModel {
  const factory CommentUserModel({
    required int id,
    required String username,
    String?
    avatarUrl, // Nullable to match the domain entity and handle missing fields
  }) = _CommentUserModel;

  factory CommentUserModel.fromJson(Map<String, dynamic> json) =>
      _$CommentUserModelFromJson(json);
}

extension CommentUserModelX on CommentUserModel {
  CommentUser toEntity() {
    return CommentUser(id: id, username: username, avatarUrl: avatarUrl);
  }
}
