import 'package:decibel/core/theme/app_colors.dart';
import 'package:decibel/features/library/presentation/widgets/action_buttons.dart';
import 'package:decibel/features/library/presentation/widgets/button.dart';
import 'package:decibel/features/library/presentation/widgets/media_collection.dart';
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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 2. Add a ScrollController and a boolean state variable
  late ScrollController _scrollController;
  bool _showAppBarIcon = false;
  final user = const UserProfile(
    name: 'Ziad Abdelraouf',
    location: 'Cairo, Egypt',
    followers: 1200,
    following: 300,
    bio:
        'Music l over and audio enthusiast. Sharing my favorite tracks and playlists.',
  );

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // 3. Add a listener to check the scroll position
    _scrollController.addListener(() {
      // 80 is the scroll offset (in pixels) where the icon will trigger.
      // You can adjust this number up or down!
      if (_scrollController.offset > 80 && !_showAppBarIcon) {
        setState(() => _showAppBarIcon = true);
      } else if (_scrollController.offset <= 80 && _showAppBarIcon) {
        setState(() => _showAppBarIcon = false);
      }
    });
  }

  @override
  void dispose() {
    // Always dispose controllers to prevent memory leaks
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 38,
        leading: Button(
          icon: Icons.arrow_back_rounded,
          onPressed: () => context.pop(),
        ),

        // 4. Add the AnimatedOpacity to the title property
        centerTitle: true,
        // The title now contains a Row with a small circle and the name
        title: AnimatedOpacity(
          opacity: _showAppBarIcon ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Row(
            // mainAxisSize is crucial here so it stays perfectly centered!
            mainAxisSize: MainAxisSize.min,
            children: [
              // Small Profile Circle
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey, // TODO: Replace with your image/color
                ),
                // If your ProfileIcon() takes a size parameter, you can use it here instead!
                child: const ProfileIcon(),
              ),
              const SizedBox(width: 10), // Space between circle and name
              // The Name
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Or AppColors.textPrimary
                ),
              ),
            ],
          ),
        ),

        actions: [
          Button(icon: Icons.share, onPressed: () {}),
          Button(icon: Icons.cast, onPressed: () {}),
        ],
      ),

      // 5. IMPORTANT: Attach the controller to your scrollable view
      body: SingleChildScrollView(
        controller: _scrollController,
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
            const SizedBox(height: 16),
            ActionButtons(),
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
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Tile(
              title: "Pinned to Spotlight",
              subtitle: "Pin items to your spotlight",
              buttonText: "Edit",
              onButtonPressed: () => {/* TODO: Handle edit spotlight action */},
            ),
            SizedBox(height: 20),
            MediaCollection(),
          ],
        ),
      ),
    );
  }
}
