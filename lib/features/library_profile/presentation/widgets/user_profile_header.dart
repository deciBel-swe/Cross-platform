import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/user_profile.dart';
import 'expandable_bio.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({required this.user, super.key});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
        Text(
          user.username,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onPrimary,
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
              onTap: () {},
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
    );
  }
}
