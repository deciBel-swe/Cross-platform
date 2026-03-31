import 'package:freezed_annotation/freezed_annotation.dart';

import 'comment_user_model.dart';

part 'comment_reply_model.freezed.dart';
part 'comment_reply_model.g.dart';

@freezed
class CommentReplyModel with _$CommentReplyModel {
  const factory CommentReplyModel({
    @JsonKey(name: 'id') required int commentId,
    required CommentUserModel user,
    required String body,
    DateTime? createdAt,
  }) = _CommentReplyModel;

  factory CommentReplyModel.fromJson(Map<String, dynamic> json) =>
      _$CommentReplyModelFromJson(json);
}
