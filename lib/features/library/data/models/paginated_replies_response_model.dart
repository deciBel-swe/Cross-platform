import 'package:freezed_annotation/freezed_annotation.dart';

import 'comment_reply_model.dart';

part 'paginated_replies_response_model.freezed.dart';
part 'paginated_replies_response_model.g.dart';

@freezed
class PaginatedRepliesResponseModel with _$PaginatedRepliesResponseModel {
  const factory PaginatedRepliesResponseModel({
    @Default([]) List<CommentReplyModel> content,
    int? pageNumber,
    int? pageSize,
    int? totalElements,
    int? totalPages,
    bool? isLast,
  }) = _PaginatedRepliesResponseModel;

  factory PaginatedRepliesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedRepliesResponseModelFromJson(json);
}
