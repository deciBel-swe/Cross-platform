import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';

import '../../domain/entities/user_profile.dart';
import '../../../library_profile/presentation/providers/web_profiles_provider.dart';
import '../widgets/action_buttons.dart';
import '../widgets/button.dart';
import '../widgets/media_collection.dart';
import '../widgets/profile_icon.dart';
import '../widgets/tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ScrollController _scrollController;
  bool _showAppBarIcon = false;

  final user = const UserProfile(
    name: 'Ziad Abdelraouf',
    location: 'Cairo, Egypt',
    followers: 1200,
    following: 300,
    bio:
        'Music lover and audio enthusiast. Sharing my favorite tracks and playlists.',
  );

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.offset > 80 && !_showAppBarIcon) {
        setState(() => _showAppBarIcon = true);
      } else if (_scrollController.offset <= 80 && _showAppBarIcon) {
        setState(() => _showAppBarIcon = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                context.push(RoutePaths.editWebLink);
              },
              child: const ProfileIcon(),
            ),
            const SizedBox(height: 14),
            _UserProfileHeader(user: user),
            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, child) {
                final socialLinks = ref.watch(webProfilesProvider);
                return ActionButtons(socialLinks: socialLinks);
              },
            ),
            Text(
              user.bio,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.onPrimary),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {},
                child: Text(
                  'Show more',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.google),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Tile(
              title: "Pinned to Spotlight",
              subtitle: "Pin items to your spotlight",
              buttonText: "Edit",
              onButtonPressed: () {},
            ),
            const SizedBox(height: 20),
            const MediaCollection(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      scrolledUnderElevation: 0,
      surfaceTintColor: AppColors.transparent,
      leadingWidth: 38,
      leading: Button(
        icon: Icons.arrow_back_rounded,
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(RoutePaths.library);
          }
        },
      ),
      centerTitle: true,
      title: AnimatedOpacity(
        opacity: _showAppBarIcon ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
              ),
              child: const ProfileIcon(),
            ),
            const SizedBox(width: 10),
            Text(
              user.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onPrimary,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Button(icon: Icons.share, onPressed: () {}),
        Button(icon: Icons.cast, onPressed: () {}),
      ],
    );
  }
}

class _UserProfileHeader extends StatelessWidget {
  const _UserProfileHeader({required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.name,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onPrimary,
          ),
        ),
        Text(
          user.location,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.onPrimary),
        ),
        const SizedBox(height: 8),
        Text(
          '${user.followers} followers - ${user.following} following',
          style: textTheme.bodyMedium?.copyWith(color: AppColors.onPrimary),
        ),
      ],
    );
  }
}
