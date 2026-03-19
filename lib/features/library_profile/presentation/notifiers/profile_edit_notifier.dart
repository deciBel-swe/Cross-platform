import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart'; // Adjust to where your getIt instance is defined
import '../../domain/entities/public_profile_social_links.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../providers/web_profiles_provider.dart';
import 'user_profile_notifier.dart';

final profileEditProvider =
    StateNotifierProvider<ProfileEditNotifier, AsyncValue<void>>(
      (ref) => ProfileEditNotifier(ref),
    );

class ProfileEditNotifier extends StateNotifier<AsyncValue<void>> {
  ProfileEditNotifier(this.ref) : super(const AsyncData(null));
  final Ref ref;

  Future<bool> updateGeneralInfo({
    required String bio,
    required String city,
    required String country,
    required List<String> genres,
  }) async {
    state = const AsyncLoading();

    final repository = getIt<ProfileRepository>();
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
