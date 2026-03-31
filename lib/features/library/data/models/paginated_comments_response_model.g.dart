// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_comments_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginatedCommentsResponseModelImpl
_$$PaginatedCommentsResponseModelImplFromJson(Map<String, dynamic> json) =>
    _$PaginatedCommentsResponseModelImpl(
      content:
          (json['content'] as List<dynamic>?)
              ?.map(
                (e) => PostCommentResponseModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
      pageNumber: (json['pageNumber'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      totalElements: (json['totalElements'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
      isLast: json['isLast'] as bool?,
    );

Map<String, dynamic> _$$PaginatedCommentsResponseModelImplToJson(
  _$PaginatedCommentsResponseModelImpl instance,
) => <String, dynamic>{
  'content': instance.content,
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'totalElements': instance.totalElements,
  'totalPages': instance.totalPages,
  'isLast': instance.isLast,
};
