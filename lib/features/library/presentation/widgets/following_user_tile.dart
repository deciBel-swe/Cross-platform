import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/following_user.dart';
import '../../../library_profile/presentation/widgets/pro_badge.dart';

class FollowingUserTile extends StatelessWidget {
  const FollowingUserTile({
    required this.user,
    required this.onTap,
    super.key,
  });

  final FollowingUser user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isPro = (user.tier ?? '').toUpperCase().contains('PRO');

    return Material(
      color: AppColors.background,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMd,
            vertical: AppDimensions.paddingMd,
          ),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.surfaceVariant,
                backgroundImage:
                    user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                        ? NetworkImage(user.avatarUrl!)
                        : null,
                child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                    ? const Icon(
                        Icons.person,
                        color: AppColors.textMuted,
                        size: 28,
                      )
                    : null,
              ),
              SizedBox(width: AppDimensions.paddingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
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
                        if (isPro) ...<Widget>[
                          SizedBox(width: AppDimensions.paddingXs),
                          ProBadge(),
                        ],
                      ],
                    ),
                    SizedBox(height: AppDimensions.paddingXs),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.person,
                          size: 15,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Following',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppDimensions.paddingMd),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusXl),
                ),
                child: Text(
                  'Following',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}