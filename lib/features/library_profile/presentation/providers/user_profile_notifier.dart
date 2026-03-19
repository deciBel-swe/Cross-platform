import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart'; // Adjust to where your getIt instance is defined
import '../../domain/entities/public_profile_social_links.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import 'web_profiles_provider.dart';

class UserProfileNotifier extends AsyncNotifier<UserProfile> {
  @override
  Future<UserProfile> build() async {
    // This runs automatically when the provider is first watched.
    return _fetchProfile();
  }

  Future<UserProfile> _fetchProfile() async {
    final repository = getIt<ProfileRepository>();
    
    final result = await repository.getUserProfile();

    return result.fold(
      (failure) {
        throw Exception(failure.message);
      },
      (profile) {
        ref.read(webProfilesProvider.notifier).setInitialLinks(
        profile.socialLinks ?? const PublicProfileSocialLinks(),
      );
        return profile;
      },
    );
  }

}

final userProfileProvider = AsyncNotifierProvider<UserProfileNotifier, UserProfile>(
  () => UserProfileNotifier(),
);