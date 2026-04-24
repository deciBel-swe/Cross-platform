import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/comment.dart';

import 'comment_user_model.dart';

part 'post_comment_response_model.freezed.dart';

part 'post_comment_response_model.g.dart';

@freezed
class PostCommentResponseModel with _$PostCommentResponseModel {
  const factory PostCommentResponseModel({
    @JsonKey(name: 'id') required int commentid,

    required CommentUserModel user,

    required String body,

    int? timestampSeconds,

    DateTime? createdAt,

    int? replycount,

    int? replyToCommentId,
  }) = _PostCommentResponseModel;

  const PostCommentResponseModel._();

  factory PostCommentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PostCommentResponseModelFromJson(json);

  Comment toEntity() {
    return Comment(
      commentid: commentid,

      user: user.toEntity(),

      body: body,

      timestampSeconds: timestampSeconds,

      createdAt: createdAt ?? DateTime.now(),

      replycount: replycount ?? 0,

      replyToCommentId: replyToCommentId,
    );
  }
}
