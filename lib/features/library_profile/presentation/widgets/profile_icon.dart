import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/user_profile_provider.dart';
import '../utils/profile_image_path_utils.dart';

class ProfileIcon extends ConsumerStatefulWidget {
  const ProfileIcon({super.key});

  @override
  ConsumerState<ProfileIcon> createState() => _ProfileIconState();
}

class _ProfileIconState extends ConsumerState<ProfileIcon> {
  String? _lastKnownImage;

  Widget _buildImage(String? imagePath) {
    if (imagePath == null) {
      return const Icon(Icons.person, size: 64, color: AppColors.outline);
    }

    if (ProfileImagePathUtils.isRemote(imagePath)) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: imagePath,
          width: 128,
          height: 128,
          fit: BoxFit.cover,
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          placeholderFadeInDuration: Duration.zero,
          placeholder: (context, url) => const SizedBox.expand(),
          errorWidget: (context, url, error) =>
              const Icon(Icons.person, size: 64, color: AppColors.outline),
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
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.person, size: 64, color: AppColors.outline),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedImage = ref
        .watch(userProfileProvider)
        .value
        ?.fold(
          (failure) => null,
          (userProfile) => userProfile.profileDetails.profilePic,
        );

    if (selectedImage != null && selectedImage.isNotEmpty) {
      _lastKnownImage = selectedImage;
    }

    final effectiveImage = (selectedImage != null && selectedImage.isNotEmpty)
        ? selectedImage
        : _lastKnownImage;

    return Semantics(
      button: true,
      image: true,
      label: 'View profile picture',
      child: GestureDetector(
        onTap: () {
          if (effectiveImage != null) {
            context.push('/profile-image', extra: effectiveImage);
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
            child: _buildImage(effectiveImage),
          ),
        ),
      ),
    );
  }
}
