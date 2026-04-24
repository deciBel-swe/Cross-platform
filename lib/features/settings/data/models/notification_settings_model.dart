import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/notification_settings.dart';

part 'notification_settings_model.freezed.dart';
part 'notification_settings_model.g.dart';

@freezed
class NotificationSettingsModel with _$NotificationSettingsModel {
  const factory NotificationSettingsModel({
    @Default(true) bool notifyOnFollow,
    @Default(true) bool notifyOnLike,
    @Default(true) bool notifyOnRepost,
    @Default(true) bool notifyOnComment,
    @Default(true) bool notifyOnDM,
  }) = _NotificationSettingsModel;

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsModelFromJson(json);
}

extension NotificationSettingsModelMapper on NotificationSettingsModel {
  NotificationSettings toEntity() {
    return NotificationSettings(
      notifyOnFollow: notifyOnFollow,
      notifyOnLike: notifyOnLike,
      notifyOnRepost: notifyOnRepost,
      notifyOnComment: notifyOnComment,
      notifyOnDM: notifyOnDM,
    );
  }
}

extension NotificationSettingsMapper on NotificationSettings {
  NotificationSettingsModel toModel() {
    return NotificationSettingsModel(
      notifyOnFollow: notifyOnFollow,
      notifyOnLike: notifyOnLike,
      notifyOnRepost: notifyOnRepost,
      notifyOnComment: notifyOnComment,
      notifyOnDM: notifyOnDM,
    );
  }
}
