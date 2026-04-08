// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_tracks_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginatedTracksModelImpl _$$PaginatedTracksModelImplFromJson(
  Map<String, dynamic> json,
) => _$PaginatedTracksModelImpl(
  content: json['content'] == null
      ? const <TrackModel>[]
      : _trackListFromJson(json['content'] as List?),
  pageNumber: (json['pageNumber'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  totalElements: (json['totalElements'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  isLast: json['isLast'] as bool,
);

Map<String, dynamic> _$$PaginatedTracksModelImplToJson(
  _$PaginatedTracksModelImpl instance,
) => <String, dynamic>{
  'content': _trackListToJson(instance.content),
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'totalElements': instance.totalElements,
  'totalPages': instance.totalPages,
  'isLast': instance.isLast,
};
