import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/user_profile.dart';

class ProfileImageHeader extends StatelessWidget {
  const ProfileImageHeader({
    super.key,
    required this.user,
    this.localCoverPic,
    this.localProfilePic,
    required this.onPickImage,
  });
  final UserProfile user;
  final File? localCoverPic;
  final File? localProfilePic;
  final void Function(bool isProfilePic) onPickImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Cover Photo
          GestureDetector(
            onTap: () => onPickImage(false),
            child: Container(
              height: 160,
              width: double.infinity,
              color: AppColors.surface,
              child: localCoverPic != null
                  ? Image.file(localCoverPic!, fit: BoxFit.cover)
                  : (user.profileDetails.coverPic != null
                        ? Image.network(
                            user.profileDetails.coverPic!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.add_a_photo,
                              color: AppColors.textSecondary,
                            ),
                          )),
            ),
          ),

          // Profile Photo
          Positioned(
            bottom: 0,
            left: 16,
            child: GestureDetector(
              onTap: () => onPickImage(true),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.background,
                    child: CircleAvatar(
                      radius: 46,
                      backgroundColor: AppColors.surface,
                      child: ClipOval(
                        child: SizedBox(
                          width: 92,
                          height: 92,
                          child: localProfilePic != null
                              ? Image.file(localProfilePic!, fit: BoxFit.cover)
                              : (user.profileDetails.profilePic != null
                                    ? Image.network(
                                        user.profileDetails.profilePic!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.person,
                                                  size: 40,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                      )
                                    : const Icon(
                                        Icons.person,
                                        size: 40,
                                        color: AppColors.textSecondary,
                                      )),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Cover Photo Camera Icon
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
