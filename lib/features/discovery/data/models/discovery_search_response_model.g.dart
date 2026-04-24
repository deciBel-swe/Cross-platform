// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_search_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DiscoverySearchResponseModelImpl _$$DiscoverySearchResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$DiscoverySearchResponseModelImpl(
  users:
      (json['users'] as List<dynamic>?)
          ?.map((e) => DiscoveryUserModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <DiscoveryUserModel>[],
  tracks:
      (json['tracks'] as List<dynamic>?)
          ?.map((e) => DiscoveryTrackModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <DiscoveryTrackModel>[],
  playlists:
      (json['playlists'] as List<dynamic>?)
          ?.map(
            (e) => DiscoveryPlaylistModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <DiscoveryPlaylistModel>[],
  pageNumber: (json['pageNumber'] as num?)?.toInt() ?? 0,
  pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
  totalElements: (json['totalElements'] as num?)?.toInt() ?? 0,
  totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
  isLast: json['isLast'] as bool? ?? true,
);

Map<String, dynamic> _$$DiscoverySearchResponseModelImplToJson(
  _$DiscoverySearchResponseModelImpl instance,
) => <String, dynamic>{
  'users': instance.users,
  'tracks': instance.tracks,
  'playlists': instance.playlists,
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'totalElements': instance.totalElements,
  'totalPages': instance.totalPages,
  'isLast': instance.isLast,
};
