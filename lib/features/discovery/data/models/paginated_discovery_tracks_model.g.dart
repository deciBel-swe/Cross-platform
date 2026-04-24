// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_discovery_tracks_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginatedDiscoveryTracksModelImpl
_$$PaginatedDiscoveryTracksModelImplFromJson(Map<String, dynamic> json) =>
    _$PaginatedDiscoveryTracksModelImpl(
      content:
          (json['content'] as List<dynamic>?)
              ?.map(
                (e) => DiscoveryTrackModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <DiscoveryTrackModel>[],
      pageNumber: (json['pageNumber'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      totalElements: (json['totalElements'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      isLast: json['isLast'] as bool? ?? true,
    );

Map<String, dynamic> _$$PaginatedDiscoveryTracksModelImplToJson(
  _$PaginatedDiscoveryTracksModelImpl instance,
) => <String, dynamic>{
  'content': instance.content,
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'totalElements': instance.totalElements,
  'totalPages': instance.totalPages,
  'isLast': instance.isLast,
};
