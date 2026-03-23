import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_settings.freezed.dart';
part 'social_settings.g.dart'; // This is for json_serializable

@freezed
class SocialSettings with _$SocialSettings {
  const factory SocialSettings({
    @Default(false) bool isPrivate,
    @Default(true) bool showHistory,
  }) = _SocialSettings;

  // The generated fromJson factory
  factory SocialSettings.fromJson(Map<String, dynamic> json) =>
      _$SocialSettingsFromJson(json);
}
