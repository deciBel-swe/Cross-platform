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
  releaseDate: json['releaseDate'] as String,
  waveFormData: (json['waveFormData'] as List<dynamic>)
      .map((e) => (e as num).toDouble())
      .toList(),
  description: json['description'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$$TrackMetadataModelImplToJson(
  _$TrackMetadataModelImpl instance,
) => <String, dynamic>{
  'title': instance.title,
  'genre': instance.genre,
  'isPrivate': instance.isPrivate,
  'releaseDate': instance.releaseDate,
  'waveFormData': instance.waveFormData,
  'description': instance.description,
  'tags': instance.tags,
};
