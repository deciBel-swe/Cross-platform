import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart'; // Adjust to where your getIt instance is defined
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

class UserProfileNotifier extends AsyncNotifier<UserProfile> {
  @override
  Future<UserProfile> build() async {
    // This runs automatically when the provider is first watched.
    return _fetchProfile();
  }

  Future<UserProfile> _fetchProfile() async {
    // 1. Grab the repository using get_it!
    final repository = getIt<ProfileRepository>();
    
    // 2. Make the call
    final result = await repository.getUserProfile();

    // 3. Fold the Either result
    return result.fold(
      (failure) {
        // By throwing an error on the Left side, Riverpod will automatically
        // catch this and turn the UI state into AsyncValue.error().
        throw Exception(failure.message);
      },
      (profile) {
        // On the Right side, return the clean entity to populate the UI.
        return profile;
      },
    );
  }

  // You can easily add your update logic here later!
  // Future<void> updateSocials(PublicProfileSocialLinks links) async { ... }
}

// 4. Expose the Notifier to your UI
final userProfileProvider = AsyncNotifierProvider<UserProfileNotifier, UserProfile>(
  () => UserProfileNotifier(),
);