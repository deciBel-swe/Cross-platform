import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/public_profile_social_links.dart';
import '../providers/user_profile_provider.dart';
import '../providers/web_profiles_provider.dart';

class ProfileEditNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> updateGeneralInfo({
    required String bio,
    required String city,
    required String country,
    required List<String> genres,
    required PublicProfileSocialLinks socialLinks,
  }) async {
    state = const AsyncLoading();

    // 4. Using ref.read instead of calling getIt directly
    final repository = ref.read(profileRepositoryProvider);

    final result = await repository.updateProfile(
      bio: bio,
      city: city,
      country: country,
      favoriteGenres: genres,
      socialLinks: socialLinks,
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
