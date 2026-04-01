import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/user_profile_provider.dart';
import '../utils/profile_image_path_utils.dart';

class ProfileIcon extends ConsumerWidget {
  const ProfileIcon({super.key});

  Widget _buildImage(String? imagePath) {
    if (imagePath == null) {
      return const Icon(Icons.person, size: 64, color: AppColors.outline);
    }

    if (ProfileImagePathUtils.isRemote(imagePath)) {
      return ClipOval(
        child: Image.network(
          imagePath,
          width: 128,
          height: 128,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.person,
            size: 64,
            color: AppColors.outline,
          ),
        ),
      );
    }

    final localPath = ProfileImagePathUtils.localFilePath(imagePath);
    if (localPath == null) {
      return const Icon(Icons.person, size: 64, color: AppColors.outline);
    }

    return ClipOval(
      child: Image.file(
        File(localPath),
        width: 128,
        height: 128,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.person,
          size: 64,
          color: AppColors.outline,
        ),
      ),
    );
  }

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
      onTap: () {
        if (selectedImage != null) {
          context.push('/profile-image', extra: selectedImage);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No profile picture to view.')),
          );
        }
      },
      child: FittedBox(
        fit: BoxFit.contain,
        child: CircleAvatar(
          radius: 64,
          backgroundColor: AppColors.surface,
          child: _buildImage(selectedImage),
        ),
      ),
    );
  }
}