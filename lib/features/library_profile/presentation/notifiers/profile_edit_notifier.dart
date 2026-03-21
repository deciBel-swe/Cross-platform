import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_profile_provider.dart';
import '../providers/web_profiles_provider.dart';


class ProfileEditNotifier extends AsyncNotifier<void> {
  
  @override
  FutureOr<void> build() {
  }

  Future<bool> updateGeneralInfo({
    required String bio,
    required String city,
    required String country,
    required List<String> genres,
  }) async {
    state = const AsyncLoading();

    // 4. Using ref.read instead of calling getIt directly
    final repository = ref.read(profileRepositoryProvider);
    
    final result = await repository.updateProfile(
      bio: bio,
      city: city,
      country: country,
      favoriteGenres: genres,
    );

    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (success) {
        ref.invalidate(userProfileProvider);
        state = const AsyncData(null);
        return true;
      },
    );
  }
}

