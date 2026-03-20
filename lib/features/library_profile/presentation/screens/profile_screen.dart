import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/user_profile.dart';
import '../notifiers/user_profile_notifier.dart';
import '../providers/web_profiles_provider.dart';
import '../widgets/action_buttons.dart';
import '../widgets/button.dart';
import '../widgets/expandable_bio.dart';
import '../widgets/media_collection.dart';
import '../widgets/profile_icon.dart';
import '../widgets/tile.dart';
import '../widgets/user_profile_header.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late ScrollController _scrollController;
  bool _showAppBarIcon = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 80 && !_showAppBarIcon) {
      setState(() => _showAppBarIcon = true);
    } else if (_scrollController.offset <= 80 && _showAppBarIcon) {
      setState(() => _showAppBarIcon = false);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Watch the FutureProvider from your architecture
    final userProfileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: userProfileAsync.maybeWhen(
        data: (user) => _buildAppBar(context, user),
        orElse: () => _buildFallbackAppBar(context),
      ),
      body: userProfileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.wifi_off_rounded, // Or Icons.error_outline
                  color: AppColors
                      .surface, // Adjust to an error color if you have one
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  'Oops! Something went wrong.',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  // This displays the clean Failure message we set up in the Repository
                  error.toString().replaceAll('Exception: ', ''),
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.onPrimary),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.invalidate(userProfileProvider);
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        data: (user) => RefreshIndicator(
          onRefresh: () async => ref.refresh(userProfileProvider.future),
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Stack(
              children: [
                // 1. Cover Photo in the back
                _ProfileCoverPhoto(imageUrl: user.profileDetails.coverPic),

                // 2. Profile Content in the front
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 120),
                      const ProfileIcon(),
                      const SizedBox(height: 14),
                      UserProfileHeader(user: user),
                      const SizedBox(height: 16),
                      Consumer(
                        builder: (context, ref, child) {
                          final socialLinks = ref.watch(webProfilesProvider);
                          return ActionButtons(socialLinks: socialLinks);
                        },
                      ),
                      if (user.profileDetails.bio != null) ...[
                        ExpandableBio(bio: user.profileDetails.bio!),
                        const SizedBox(height: 8),
                      ],
                      const SizedBox(height: 16),
                      Tile(
                        title: "Pinned to Spotlight",
                        subtitle: "Pin items to your spotlight",
                        buttonText: "Edit",
                        onButtonPressed: () =>
                            context.push(RoutePaths.editProfile),
                      ),
                      const SizedBox(height: 20),
                      const MediaCollection(),
                      const SizedBox(height: 40), // Bottom padding
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildFallbackAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      leading: Button(
        icon: Icons.arrow_back_rounded,
        onPressed: () =>
            context.canPop() ? context.pop() : context.go(RoutePaths.library),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, UserProfile user) {
    return AppBar(
      backgroundColor: AppColors.background,
      scrolledUnderElevation: 0,
      surfaceTintColor: AppColors.transparent,
      leadingWidth: 38,
      leading: Button(
        icon: Icons.arrow_back_rounded,
        onPressed: () =>
            context.canPop() ? context.pop() : context.go(RoutePaths.library),
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
              user.username,
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


class _ProfileCoverPhoto extends StatelessWidget {
  const _ProfileCoverPhoto({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Fixed height for the cover area
      width: double.infinity,
      child: imageUrl != null
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _buildPlaceholder();
              },
            )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surface,
      child: const Icon(Icons.image, color: AppColors.onPrimary, size: 40),
    );
  }
}
