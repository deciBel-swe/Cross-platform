import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/user_profile.dart';
class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final locationStr =
        (user.profileDetails.city != null &&
            user.profileDetails.country != null)
        ? '${user.profileDetails.city}, ${user.profileDetails.country}'
        : 'No location';

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
        const SizedBox(height: 8),

        // The new tappable stats row
        Row(
          children: [
            _StatButton(
              count: user
                  .stats
                  .followers, // Or followersCount if you renamed it in the entity
              label: 'followers',
              onTap: () {
                debugPrint('Tapped: Navigate to Followers');
                // TODO: Replace with actual navigation
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                '-',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ),
            _StatButton(
              count: user
                  .stats
                  .following, // Or followingCount if you renamed it in the entity
              label: 'following',
              onTap: () {
                debugPrint('Tapped: Navigate to Following');
                // TODO: Replace with actual navigation
              },
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
        padding: const EdgeInsets.symmetric(vertical: 4.0),
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
