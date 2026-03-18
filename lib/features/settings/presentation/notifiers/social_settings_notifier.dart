import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/social_settings.dart';
import '../providers/social_settings_provider.dart';

class SocialSettingsNotifier extends AsyncNotifier<SocialSettings> {
  @override
  @override
FutureOr<SocialSettings> build() async {
  final repo = ref.watch(socialSettingsRepositoryProvider);
  
  return repo.getSocialSettings(); 
}

  Future<void> toggleProfilePrivacy(bool isPrivate) async {
    final previous = state.value!;
    final updated = previous.copyWith(isPrivate: isPrivate);
    
    await _applyUpdate(updated, previous);
  }

  Future<void> toggleHistoryVisibility(bool showHistory) async {
    final previous = state.value!;
    final updated = previous.copyWith(showHistory: showHistory);
    
    await _applyUpdate(updated, previous);
  }

  Future<void> _applyUpdate(SocialSettings next, SocialSettings prev) async {
    state = AsyncData(next); 

    try {
      await ref.read(socialSettingsRepositoryProvider).updateSocialSettings(next);
    } catch (e) {
      state = AsyncData(prev); // Rollback on failure
      rethrow;
    }
  }
}

final socialSettingsProvider = AsyncNotifierProvider<SocialSettingsNotifier, SocialSettings>(
  SocialSettingsNotifier.new,
);