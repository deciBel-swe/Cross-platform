import 'package:decibel/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/profile_image_provider.dart';

class ProfileIcon extends ConsumerWidget {
  const ProfileIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImage = ref.watch(profileImageProvider);

    return GestureDetector(
      onTap: () => ref.read(profileImageProvider.notifier).pickImage(),
      child: FittedBox(
        fit: BoxFit.contain,
        child: CircleAvatar(
          radius: 64,
          backgroundColor: Colors.grey[200],
          backgroundImage: selectedImage != null 
              ? FileImage(selectedImage) 
              : null,
          child: selectedImage == null
              ? const Icon(Icons.person, size: 64, color: AppColors.outline)
              : null,
        ),
      ),
    );
  }
}