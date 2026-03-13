// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_metadata_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrackMetadataModelImpl _$$TrackMetadataModelImplFromJson(
  Map<String, dynamic> json,
) => _$TrackMetadataModelImpl(
  title: json['title'] as String,
  genre: json['genre'] as String,
  isPrivate: json['isPrivate'] as bool,
  description: json['description'] as String?,
  releasedDate: json['releasedDate'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$$TrackMetadataModelImplToJson(
  _$TrackMetadataModelImpl instance,
) => <String, dynamic>{
  'title': instance.title,
  'genre': instance.genre,
  'isPrivate': instance.isPrivate,
  'description': instance.description,
  'releasedDate': instance.releasedDate,
  'tags': instance.tags,
};
