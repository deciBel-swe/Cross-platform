import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/user_profile_provider.dart';
import '../utils/profile_image_path_utils.dart';

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
          child: selectedImage == null
              ? const Icon(Icons.person, size: 64, color: AppColors.outline)
              : ProfileImagePathUtils.isRemote(selectedImage)
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
              : Builder(
                  builder: (context) {
                    final localPath = ProfileImagePathUtils.localFilePath(
                      selectedImage,
                    );

                    if (localPath == null) {
                      return const Icon(
                        Icons.person,
                        size: 64,
                        color: AppColors.outline,
                      );
                    }

                    return ClipOval(
                      child: Image.file(
                        File(localPath),
                        width: 128,
                        height: 128,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.person,
                              size: 64,
                              color: AppColors.outline,
                            ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
