// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SocialSettingsImpl _$$SocialSettingsImplFromJson(Map<String, dynamic> json) =>
    _$SocialSettingsImpl(
      isPrivate: json['isPrivate'] as bool? ?? false,
      showHistory: json['showHistory'] as bool? ?? true,
    );

Map<String, dynamic> _$$SocialSettingsImplToJson(
  _$SocialSettingsImpl instance,
) => <String, dynamic>{
  'isPrivate': instance.isPrivate,
  'showHistory': instance.showHistory,
};
