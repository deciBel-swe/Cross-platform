import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../data/repositories/notification_settings_repository_impl.dart';
import '../../domain/entities/notification_settings.dart';
import '../../domain/repositories/notification_settings_repository.dart';

final notificationSettingsRepositoryProvider =
    Provider<NotificationSettingsRepository>((ref) {
      return NotificationSettingsRepositoryImpl(getIt());
    });

final notificationSettingsProvider =
    AsyncNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
      NotificationSettingsNotifier.new,
    );

class NotificationSettingsNotifier
    extends AsyncNotifier<NotificationSettings> {
  late final NotificationSettingsRepository _repository =
      ref.read(notificationSettingsRepositoryProvider);

  @override
  Future<NotificationSettings> build() {
    return _repository.getNotificationSettings();
  }

  Future<void> updateSettings(NotificationSettings updated) async {
    final previous = state.valueOrNull;
    state = AsyncData(updated);

    try {
      final saved = await _repository.updateNotificationSettings(updated);
      state = AsyncData(saved);
    } catch (e, st) {
      if (previous != null) {
        state = AsyncData(previous);
      } else {
        state = AsyncError(e, st);
      }
      rethrow;
    }
  }

  Future<void> toggleFollow(bool value) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await updateSettings(current.copyWith(notifyOnFollow: value));
  }

  Future<void> toggleLike(bool value) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await updateSettings(current.copyWith(notifyOnLike: value));
  }

  Future<void> toggleRepost(bool value) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await updateSettings(current.copyWith(notifyOnRepost: value));
  }

  Future<void> toggleComment(bool value) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await updateSettings(current.copyWith(notifyOnComment: value));
  }

  Future<void> toggleDM(bool value) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await updateSettings(current.copyWith(notifyOnDM: value));
  }
}