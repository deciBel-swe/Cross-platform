import 'package:decibel/core/theme/app_colors.dart';
import 'package:decibel/features/library/presentation/widgets/button.dart';
import 'package:decibel/features/library/presentation/widgets/profile_icon.dart';
import 'package:decibel/features/library/presentation/widgets/tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 1. Create a simple data model (usually this lives in a separate file)
class UserProfile {
  final String name;
  final String location;
  final int followers;
  final int following;
  final String bio;

  const UserProfile({
    required this.name,
    required this.location,
    required this.followers,
    required this.following,
    required this.bio,
  });
}

class ProfileScreen extends StatelessWidget {
  // 2. Pass the data in via the constructor
  final user = const UserProfile(
    name: 'Ziad Abdelraouf',
    location: 'Cairo, Egypt',
    followers: 1200,
    following: 300,
    bio:
        'Music l over and audio enthusiast. Sharing my favorite tracks and playlists.',
  );

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leadingWidth: 38,
        leading: Button(
          icon: Icons.arrow_back_rounded,
          onPressed: () => context.pop(),
        ),
        actions: [
          Button(
            icon: Icons.share,
            onPressed: () {
              /* TODO: share */
            },
          ),
          Button(
            icon: Icons.cast,
            onPressed: () {
              /* TODO: cast */
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Added to prevent overflow on smaller screens
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const ProfileIcon(),
            const SizedBox(height: 14),

            // Dynamic Data using Theme styles
            Text(
              user.name,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              user.location,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${user.followers} followers - ${user.following} following',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),

            // Action Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(), // Better than minimumSize: Size.zero
                  onPressed: () {},
                  color: AppColors.textTertiary,
                  iconSize: 29,
                  icon: const Icon(Icons.edit_outlined),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  color: AppColors.textTertiary,
                  iconSize: 29,
                  icon: const Icon(Icons.shuffle),
                ),
                IconButton(
                  iconSize: 60,
                  onPressed: () {},
                  icon: const Icon(Icons.play_circle_fill),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Dynamic Bio
            Text(
              user.bio,
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            // Show More Button
            Align(
              // Aligning to the left
              alignment: Alignment.centerLeft,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {},
                child: const Text(
                  'Show more',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ), // Replaced AppColors.google for standard example
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Insights ListTile
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Your insights',
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.onPrimary,
                size: 18,
              ),
              onTap: () {
                // TODO: Navigate to insights
              },
            ),
            Tile(
              title: "Pinned to Spotlight",
              subtitle: "Pin items to your spotlight",
              buttonText: "Edit",
              onButtonPressed: () => {/* TODO: Handle edit spotlight action */},
            ),
            SizedBox(height: 14),
            Tile(
              title: 'Tracks',
              subtitle: 'View all your tracks',
              buttonText: 'See All',
              onButtonPressed: () => {/* TODO: Handle see all tracks action */},
            ),
            SizedBox(
              height: 14,
              child: Center(child: Text('No more tracks to show')),
            ),
          ],
        ),
      ),
    );
  }
}
