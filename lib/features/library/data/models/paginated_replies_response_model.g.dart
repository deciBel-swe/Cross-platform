// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_replies_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginatedRepliesResponseModelImpl
_$$PaginatedRepliesResponseModelImplFromJson(Map<String, dynamic> json) =>
    _$PaginatedRepliesResponseModelImpl(
      content:
          (json['content'] as List<dynamic>?)
              ?.map(
                (e) => CommentReplyModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      pageNumber: (json['pageNumber'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      totalElements: (json['totalElements'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
      isLast: json['isLast'] as bool?,
    );

Map<String, dynamic> _$$PaginatedRepliesResponseModelImplToJson(
  _$PaginatedRepliesResponseModelImpl instance,
) => <String, dynamic>{
  'content': instance.content,
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'totalElements': instance.totalElements,
  'totalPages': instance.totalPages,
  'isLast': instance.isLast,
};
