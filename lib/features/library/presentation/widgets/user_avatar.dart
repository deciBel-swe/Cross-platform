import 'package:flutter/material.dart';
import '../../../../core/widgets/decibel_cached_image.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.1),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null && imageUrl!.trim().isNotEmpty
          ? DecibelCachedImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              errorWidget: const Icon(
                Icons.person,
                size: 20,
                color: Colors.white54,
              ),
            )
          : const Icon(Icons.person, size: 20, color: Colors.white54),
    );
  }
}
