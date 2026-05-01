import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/subscription_tier_helper.dart';
import '../../domain/entities/user_profile.dart';
import 'expandable_bio.dart';
import 'pro_badge.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({
    required this.user,
    required this.onFollowersTap,
    required this.onFollowingTap,
    super.key,
  });

  final UserProfile user;
  final VoidCallback onFollowersTap;
  final VoidCallback onFollowingTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final tierValue = switch (user.tier) {
      UserTier.free => 'FREE',
      UserTier.pro => 'PRO',
      UserTier.artistPro => 'ARTIST_PRO',
    };
    final isPremium = SubscriptionTierHelper.isPremium(tierValue);
    final city = user.profileDetails.city?.trim() ?? '';
    final country = user.profileDetails.country?.trim() ?? '';
    final locationStr = switch ((city.isNotEmpty, country.isNotEmpty)) {
      (true, true) => '$city, $country',
      (true, false) => city,
      (false, true) => country,
      (false, false) => AppConstants.noLocation,
    };
    final bio = user.profileDetails.bio?.trim() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              user.displayName ?? user.username,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onPrimary,
              ),
            ),
            if (isPremium) ...[
              const SizedBox(width: AppConstants.spacingSmall),
              const ProBadge(),
            ],
          ],
        ),
        Text(
          '@${user.username}',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.onPrimary.withValues(alpha: 0.6),
          ),
        ),
        if (bio.isNotEmpty) ...[
          const SizedBox(height: AppConstants.spacingSmall),
          ExpandableBio(bio: bio),
        ],
        const SizedBox(height: AppConstants.spacingSmall),
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
              onTap: onFollowersTap,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingTiny,
              ),
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
              onTap: onFollowingTap,
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
    return Semantics(
      button: true,
      label: '$count $label',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.spacingTiny,
          ),
          child: ExcludeSemantics(
            child: RichText(
              text: TextSpan(
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.onPrimary),
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
        ),
      ),
    );
  }
}
