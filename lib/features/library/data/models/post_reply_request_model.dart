import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_reply_request_model.freezed.dart';
part 'post_reply_request_model.g.dart';

@freezed
class PostReplyRequestModel with _$PostReplyRequestModel {
  const factory PostReplyRequestModel({required String body}) =
      _PostReplyRequestModel;

  factory PostReplyRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PostReplyRequestModelFromJson(json);
}
