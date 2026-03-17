import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/social_settings_repositor_impl.dart';

class SocialSettingsState {
  final bool showWaveform;
  final bool showActivities;
  final bool showTopFan;

  SocialSettingsState({
    required this.showWaveform,
    required this.showActivities,
    required this.showTopFan,
  });

  SocialSettingsState copyWith({bool? waveform, bool? activities, bool? topFan}) {
    return SocialSettingsState(
      showWaveform: waveform ?? showWaveform,
      showActivities: activities ?? showActivities,
      showTopFan: topFan ?? showTopFan,
    );
  }
}

class SocialSettingsNotifier extends AsyncNotifier<SocialSettingsState> {
  @override
  FutureOr<SocialSettingsState> build() async {
    final repo = ref.watch(socialSettingsRepositoryProvider);
    final data = await repo.getSettings();
    
    return SocialSettingsState(
      showWaveform: data['waveform']!,
      showActivities: data['activities']!,
      showTopFan: data['top_fan']!,
    );
  }

  Future<void> setToggle(String key, bool value) async {
    final repo = ref.read(socialSettingsRepositoryProvider);
    final previousState = state.value!;

    // 1. Optimistic UI Update
    state = AsyncData(_mapToggleToState(previousState, key, value));

    try {
      // 2. Persistent Update
      await repo.updateSetting(key, value);
    } catch (e) {
      // 3. Rollback on failure
      state = AsyncData(previousState);
    }
  }

  SocialSettingsState _mapToggleToState(SocialSettingsState current, String key, bool val) {
    switch (key) {
      case 'waveform': return current.copyWith(waveform: val);
      case 'activities': return current.copyWith(activities: val);
      case 'top_fan': return current.copyWith(topFan: val);
      default: return current;
    }
  }
}

final socialSettingsProvider = AsyncNotifierProvider<SocialSettingsNotifier, SocialSettingsState>(
  SocialSettingsNotifier.new,
);