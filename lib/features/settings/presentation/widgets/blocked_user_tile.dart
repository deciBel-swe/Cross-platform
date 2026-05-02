import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/blocked_user.dart';

class BlockedUserTile extends StatelessWidget {
  const BlockedUserTile({
    required this.user,
    required this.onUnblockTap,
    super.key,
  });

  final BlockedUser user;
  final VoidCallback onUnblockTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMd,
          vertical: AppDimensions.paddingMd,
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.surfaceVariant,
              backgroundImage:
                  user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                      ? NetworkImage(user.avatarUrl!)
                      : null,
              child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                  ? const Icon(
                      Icons.person,
                      color: AppColors.textMuted,
                    )
                  : null,
            ),
            const SizedBox(width: AppDimensions.paddingMd),
            Expanded(
              child: Text(
                user.username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headlineMedium.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingMd),
            TextButton(
              onPressed: onUnblockTap,
              child: Text(
                'Unblock',
                style: AppTextStyles.labelLarge.copyWith(
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}