import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/decibel_cached_image.dart';
import '../../domain/entities/user_profile.dart';
import '../utils/profile_image_path_utils.dart';

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

  void _showProfileOptions(BuildContext parentContext, String? imagePath) {
    showModalBottomSheet<Widget>(
      context: parentContext,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('View Profile Picture'),
                onTap: () {
                  sheetContext.pop();
                  if (imagePath != null) {
                    parentContext.push('/profile-image', extra: imagePath);
                  } else {
                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      const SnackBar(
                        content: Text('No profile picture to view.'),
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Change Profile Picture'),
                onTap: () {
                  sheetContext.pop();
                  onPickImage(true);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRemoteOrLocalImage({
    required String imagePath,
    required BoxFit fit,
    required Widget fallback,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    if (ProfileImagePathUtils.isRemote(imagePath)) {
      return DecibelCachedImage(
        imageUrl: imagePath,
        fit: fit,
        filterQuality: filterQuality,
        errorWidget: fallback,
        placeholder: fallback,
      );
    }

    final localPath = ProfileImagePathUtils.localFilePath(imagePath);
    if (localPath == null) {
      return fallback;
    }

    return Image.file(
      File(localPath),
      fit: fit,
      filterQuality: filterQuality,
      errorBuilder: (context, error, stackTrace) => fallback,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.sizeOf(context).width > 600;
    double coverHeight = isDesktop ? 350.0 : 160.0;
    double stackHeight = isDesktop ? 430.0 : 220.0;

    return SizedBox(
      height: stackHeight,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // --- BACKGROUND LAYER: Cover Photo ---
          SizedBox(
            height: coverHeight,
            child: Container(
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(color: AppColors.surface),
              child: localCoverPic != null
                  ? Image.file(
                      localCoverPic!,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    )
                  : (user.profileDetails.coverPic != null
                        ? _buildRemoteOrLocalImage(
                            imagePath: user.profileDetails.coverPic!,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            fallback: const Center(
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

          // --- Profile Photo ---
          Positioned(
            bottom: 0,
            left: 16,
            child: GestureDetector(
              // --- UPDATED: Call the new bottom sheet logic ---
              onTap: () {
                final activePath =
                    localProfilePic?.path ?? user.profileDetails.profilePic;
                _showProfileOptions(context, activePath);
              },
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
                                    ? _buildRemoteOrLocalImage(
                                        imagePath:
                                            user.profileDetails.profilePic!,
                                        fit: BoxFit.cover,
                                        fallback: const Icon(
                                          Icons.person,
                                          size: 40,
                                          color: AppColors.textSecondary,
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

          // --- Cover Photo Camera Icon ---
          Positioned(
            top: 16,
            right: 16,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => onPickImage(false),
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
            ),
          ),
        ],
      ),
    );
  }
}
