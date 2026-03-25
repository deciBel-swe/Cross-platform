import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/post_comment_request.dart';

part 'post_comment_request_model.freezed.dart';

@freezed
class PostCommentRequestModel with _$PostCommentRequestModel {
  const factory PostCommentRequestModel({
    required String body,
    int? timeStampedseconds,
  }) = _PostCommentRequestModel;

  factory PostCommentRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PostCommentRequestModelFromJson(json);
}

extension PostCommentRequestModelX on PostCommentRequestModel {
  PostCommentRequest toEntity() {
    return PostCommentRequest(body: body, timestampSeconds: timeStampedseconds);
  }
}
