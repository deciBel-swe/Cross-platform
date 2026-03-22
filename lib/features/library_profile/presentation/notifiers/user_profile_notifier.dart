import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart'; 
import '../../../../core/errors/failures.dart';
import '../../domain/entities/public_profile_social_links.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../providers/web_profiles_provider.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return getIt<ProfileRepository>();
});

class UserProfileNotifier extends AsyncNotifier<Either<Failure, UserProfile>> {
  
  @override
  Future<Either<Failure, UserProfile>> build() async {
    // This runs automatically when the provider is first watched.
    return _fetchProfile();
  }

  void updateState(UserProfile newUser) {
    state = AsyncData(Right(newUser));
  }
  Future<void> refreshProfile() async {
    final minLoadTime = Future.delayed(const Duration(milliseconds: 1500));
    
    final fetchTask = _fetchProfile();

    final results = await Future.wait([fetchTask, minLoadTime]);
    final newResult = results[0] as Either<Failure, UserProfile>;

    final oldState = state.value;

    newResult.fold(
      (failure) {
        if (oldState != null && oldState.isRight()) {
          return; 
        } else {
          state = AsyncData(Left(failure));
        }
      },
      (profile) {
        state = AsyncData(Right(profile));
      },
    );
  }  
  Future<Either<Failure, UserProfile>> _fetchProfile() async {
    final repository = ref.read(profileRepositoryProvider);

    final result = await repository.getUserProfile();

    return result.fold(
      (failure) {
        return Left(failure);
      },
      (profile) {
        ref
            .read(webProfilesProvider.notifier)
            .setInitialLinks(
              profile.socialLinks ?? const PublicProfileSocialLinks(),
            );
            
        return Right(profile);
      },
    );
  }
}