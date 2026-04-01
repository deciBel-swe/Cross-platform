import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/comment.dart';
import 'comment_user_model.dart';

part 'post_comment_response_model.freezed.dart';
part 'post_comment_response_model.g.dart';

@freezed
class PostCommentResponseModel with _$PostCommentResponseModel {
  const factory PostCommentResponseModel({
    @JsonKey(name: 'id') required int commentId,
    @Default(0) int replycount,
    required CommentUserModel user,
    required String body,
    int? timestampSeconds,
    required DateTime createdAt,
  }) = _PostCommentResponseModel;

  factory PostCommentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PostCommentResponseModelFromJson(json);
}

extension PostCommentResponseModelX on PostCommentResponseModel {
  Comment toEntity() {
    return Comment(
      replycount: replycount,

      commentid: commentId,
      user: user.toEntity(),
      body: body,
      timestampSeconds: timestampSeconds,
      createdAt: createdAt,
    );
  }
}
