// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_playlist_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreatePlaylistRequestImpl _$$CreatePlaylistRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreatePlaylistRequestImpl(
  title: json['title'] as String,
  description: json['description'] as String?,
  type: json['type'] as String? ?? 'PLAYLIST',
  isPrivate: json['isPrivate'] as bool? ?? true,
  coverArt: json['CoverArt'] as String?,
);

Map<String, dynamic> _$$CreatePlaylistRequestImplToJson(
  _$CreatePlaylistRequestImpl instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'type': instance.type,
  'isPrivate': instance.isPrivate,
  'CoverArt': instance.coverArt,
};
