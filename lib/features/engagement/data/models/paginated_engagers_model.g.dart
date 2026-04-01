// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_engagers_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginatedEngagersModelImpl _$$PaginatedEngagersModelImplFromJson(
  Map<String, dynamic> json,
) => _$PaginatedEngagersModelImpl(
  content:
      (json['content'] as List<dynamic>?)
          ?.map((e) => TrackEngagerModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <TrackEngagerModel>[],
  pageNumber: (json['pageNumber'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  totalElements: (json['totalElements'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  isLast: json['isLast'] as bool,
);

Map<String, dynamic> _$$PaginatedEngagersModelImplToJson(
  _$PaginatedEngagersModelImpl instance,
) => <String, dynamic>{
  'content': instance.content,
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'totalElements': instance.totalElements,
  'totalPages': instance.totalPages,
  'isLast': instance.isLast,
};
