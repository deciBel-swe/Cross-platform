// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_feed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginatedFeedModelImpl _$$PaginatedFeedModelImplFromJson(
  Map<String, dynamic> json,
) => _$PaginatedFeedModelImpl(
  content: json['content'] == null
      ? const <FeedTrackModel>[]
      : _tracksFromJson(json['content'] as List?),
  pageNumber: (json['pageNumber'] as num?)?.toInt() ?? 0,
  pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
  totalElements: (json['totalElements'] as num?)?.toInt() ?? 0,
  totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
  isLast: json['isLast'] as bool? ?? true,
);

Map<String, dynamic> _$$PaginatedFeedModelImplToJson(
  _$PaginatedFeedModelImpl instance,
) => <String, dynamic>{
  'content': _tracksToJson(instance.content),
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'totalElements': instance.totalElements,
  'totalPages': instance.totalPages,
  'isLast': instance.isLast,
};
