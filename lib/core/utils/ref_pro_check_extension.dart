import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/domain/entities/auth_state.dart';
import '../../features/auth/domain/entities/auth_user.dart' as auth;
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/library_profile/domain/entities/user_profile.dart';
import '../../features/library_profile/presentation/providers/user_profile_provider.dart';

extension RefProCheckX on WidgetRef {
  /// Returns true if the user is a Pro or Artist Pro subscriber.
  /// 
  /// Checks [userProfileProvider] as the primary source of truth,
  /// and falls back to [authStateProvider] (which reads from Secure Storage)
  /// for immediate results during startup or while offline.
  bool get isPro {
    // 1. Try to get tier from UserProfile (latest fetched data)
    final profileAsync = watch(userProfileProvider);
    final isProFromProfile = profileAsync.valueOrNull?.fold(
      (_) => null, // Failure -> fallback to auth state
      (p) => p.tier == UserTier.pro || p.tier == UserTier.artistPro,
    );

    if (isProFromProfile != null) return isProFromProfile;

    // 2. Fallback to AuthState (cached in Secure Storage)
    final authStateAsync = watch(authStateProvider);
    final authUser = authStateAsync.valueOrNull;
    
    if (authUser is AuthAuthenticated) {
      return authUser.user.tier == auth.UserTier.pro || 
             authUser.user.tier == auth.UserTier.artistPro;
    }

    return false;
  }
}
