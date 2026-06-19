import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/notification_settings.dart';
import '../../domain/repositories/notification_settings_repository.dart';
import '../providers/notification_settings_provider.dart';

final notificationSettingsProvider =
    AsyncNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
      NotificationSettingsNotifier.new,
    );

class NotificationSettingsNotifier extends AsyncNotifier<NotificationSettings> {
  late final NotificationSettingsRepository _repository = ref.read(
    notificationSettingsRepositoryProvider,
  );

  NotificationSettings? _lastSavedSettings;
  NotificationSettings? _pendingSettings;
  bool _isSaving = false;

  @override
  Future<NotificationSettings> build() async {
    final settings = await _repository.getNotificationSettings();
    _lastSavedSettings = settings;
    return settings;
  }

  Future<void> updateSettings(NotificationSettings updated) async {
    _pendingSettings = updated;
    state = AsyncData(updated);

    if (_isSaving) {
      return;
    }

    _isSaving = true;
    try {
      while (_pendingSettings != null) {
        final settingsToSave = _pendingSettings!;
        _pendingSettings = null;

        try {
          final saved = await _repository.updateNotificationSettings(
            settingsToSave,
          );
          _lastSavedSettings = saved;

          if (_pendingSettings == null) {
            state = AsyncData(saved);
          }
        } catch (e, st) {
          if (_pendingSettings == null) {
            state = AsyncError(e, st);

            final lastSavedSettings = _lastSavedSettings;
            if (lastSavedSettings != null) {
              state = AsyncData(lastSavedSettings);
            }
          }
        }
      }
    } finally {
      _isSaving = false;
    }
  }

  Future<void> toggleFollow(bool value) async {
    await _updateCurrent((current) => current.copyWith(notifyOnFollow: value));
  }

  Future<void> toggleLike(bool value) async {
    await _updateCurrent((current) => current.copyWith(notifyOnLike: value));
  }

  Future<void> toggleRepost(bool value) async {
    await _updateCurrent((current) => current.copyWith(notifyOnRepost: value));
  }

  Future<void> toggleComment(bool value) async {
    await _updateCurrent((current) => current.copyWith(notifyOnComment: value));
  }

  Future<void> toggleDM(bool value) async {
    await _updateCurrent((current) => current.copyWith(notifyOnDM: value));
  }

  Future<void> _updateCurrent(
    NotificationSettings Function(NotificationSettings current) update,
  ) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }

    await updateSettings(update(current));
  }
}
