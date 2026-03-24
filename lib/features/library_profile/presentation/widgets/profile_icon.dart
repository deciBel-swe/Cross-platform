import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/user_profile_provider.dart';

class ProfileIcon extends ConsumerWidget {
  const ProfileIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImage = ref
        .watch(userProfileProvider)
        .value
        ?.fold(
          (failure) => null,
          (userProfile) => userProfile.profileDetails.profilePic,
        );

    return GestureDetector(
      child: FittedBox(
        fit: BoxFit.contain,
        child: CircleAvatar(
          radius: 64,
          backgroundColor: AppColors.surface,
          child: selectedImage != null
              ? ClipOval(
                  child: Image.network(
                    selectedImage,
                    width: 128,
                    height: 128,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.person,
                      size: 64,
                      color: AppColors.outline,
                    ),
                  ),
                )
              : const Icon(Icons.person, size: 64, color: AppColors.outline),
        ),
      ),
    );
  }
}
