import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/paginated_comment_reply.dart';
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
  // Required to add custom methods/getters to a Freezed class
  const PaginatedRepliesResponseModel._();

  factory PaginatedRepliesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedRepliesResponseModelFromJson(json);

  /// Maps the Data Model to the Domain Entity
  PaginatedReplies toEntity() {
    return PaginatedReplies(
      content: content.map((replyModel) => replyModel.toEntity()).toList(),
      pageNumber: pageNumber,
      pageSize: pageSize,
      totalElements: totalElements,
      totalPages: totalPages,
      isLast: isLast,
    );
  }
}
