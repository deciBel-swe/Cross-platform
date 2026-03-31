import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_comment_request_model.freezed.dart';
part 'post_comment_request_model.g.dart';

@freezed
class PostCommentRequestModel with _$PostCommentRequestModel {
  const factory PostCommentRequestModel({
    required String body,
    int? timeStampseconds,
  }) = _PostCommentRequestModel;

  factory PostCommentRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PostCommentRequestModelFromJson(json);
}
