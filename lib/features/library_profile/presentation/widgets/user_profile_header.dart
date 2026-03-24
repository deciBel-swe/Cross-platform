import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/user_profile.dart';


class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({required this.user,super.key});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final locationStr = (user.profileDetails.city != null && user.profileDetails.country != null)
        ? '${user.profileDetails.city}, ${user.profileDetails.country}'
        : AppConstants.noLocation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.username,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onPrimary,
          ),
        ),
        Text(
          locationStr,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.onPrimary),
        ),
        const SizedBox(height: AppConstants.spacingSmall),

        Row(
          children: [
            _StatButton(
              count: user.stats.followers,
              label: AppConstants.followers,
              onTap: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingTiny),
              child: Text(
                AppConstants.statSeparator,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ),
            _StatButton(
              count: user.stats.following, 
              label: AppConstants.following,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _StatButton extends StatelessWidget {
  const _StatButton({
    required this.count,
    required this.label,
    required this.onTap,
  });

  final int count;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingTiny),
        child: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onPrimary),
            children: [
              TextSpan(
                text: '$count ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: label),
            ],
          ),
        ),
      ),
    );
  }
}
