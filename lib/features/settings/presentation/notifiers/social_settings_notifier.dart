import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/social_settings.dart';
import '../providers/social_settings_provider.dart';

class SocialSettingsNotifier extends AsyncNotifier<SocialSettings> {
  Timer? _debounceTimer;
  SocialSettings? _initialStateBeforeBurst;

  @override
  FutureOr<SocialSettings> build() async {
    ref.onDispose(() => _debounceTimer?.cancel());

    final repo = ref.watch(socialSettingsRepositoryProvider);
    return repo.getSocialSettings();
  }

  Future<void> toggleProfilePrivacy(bool isPrivate) async {
    final previous = state.value!;
    final updated = previous.copyWith(isPrivate: isPrivate);

    await _applyUpdate(updated);
  }

  Future<void> toggleHistoryVisibility(bool showHistory) async {
    final previous = state.value!;
    final updated = previous.copyWith(showHistory: showHistory);

    await _applyUpdate(updated);
  }

  Future<void> _applyUpdate(SocialSettings next) async {
    // 1. Capture the "initial state" before rapid updates start,
    // so we can rollback to it if the FINAL debounced request fails.
    _initialStateBeforeBurst ??= state.value;

    // 2. Perform optimistic update
    state = AsyncData(next);

    // 3. Cancel any pending sync requests
    _debounceTimer?.cancel();

    // 4. Set a new timer to sync with the backend
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final burstStart = _initialStateBeforeBurst;
      _initialStateBeforeBurst = null; // Clear now that we are attempting sync

      try {
        await ref
            .read(socialSettingsRepositoryProvider)
            .updateSocialSettings(next);
      } catch (e) {
        // 5. If it fails, rollback to the state from before the burst
        if (burstStart != null) {
          state = AsyncData(burstStart);
        }
        // Important: we can't easily "rethrow" from inside a Timer callback
        // to the original toggle caller, but the provider state itself
        // will now reflect the rollback.
      }
    });
  }
}

final socialSettingsProvider =
    AsyncNotifierProvider<SocialSettingsNotifier, SocialSettings>(
      SocialSettingsNotifier.new,
    );
