import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/paginated_comments.dart';
import 'post_comment_response_model.dart';

part 'paginated_comments_response_model.freezed.dart';
part 'paginated_comments_response_model.g.dart';

@freezed
class PaginatedCommentsResponseModel with _$PaginatedCommentsResponseModel {
  const PaginatedCommentsResponseModel._();

  const factory PaginatedCommentsResponseModel({
    @Default([]) List<PostCommentResponseModel> content,
    int? pageNumber,
    int? pageSize,
    int? totalElements,
    int? totalPages,
    bool? isLast,
  }) = _PaginatedCommentsResponseModel;

  factory PaginatedCommentsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedCommentsResponseModelFromJson(json);

  PaginatedComments toEntity() {
    return PaginatedComments(
      content: content.map((model) => model.toEntity()).toList(),
      pageNumber: pageNumber,
      pageSize: pageSize,
      totalElements: totalElements,
      totalPages: totalPages,
      isLast: isLast,
    );
  }
}
