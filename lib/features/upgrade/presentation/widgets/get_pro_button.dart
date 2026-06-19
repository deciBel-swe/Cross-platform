import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../library_profile/domain/entities/user_profile.dart';
import '../../../library_profile/presentation/providers/user_profile_provider.dart';

/// A button that navigates to the upgrade screen, only visible if the user is on the free tier.
class GetProButton extends ConsumerWidget {
  const GetProButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);

    return userProfileAsync.maybeWhen(
      data: (result) {
        return result.fold((_) => const SizedBox.shrink(), (profile) {
          if (profile.tier != UserTier.free) {
            return const SizedBox.shrink();
          }
          return Semantics(
            button: true,
            label: 'Upgrade to Decibel Pro',
            onTapHint: 'Go to upgrade screen to see plans',
            child: TextButton(
              onPressed: () => context.push(RoutePaths.upgrade),
              child: const Text(
                'GET PRO',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          );
        });
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
