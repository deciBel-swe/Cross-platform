import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/user_profile_provider.dart';
import '../providers/web_profiles_provider.dart';
import '../widgets/action_buttons.dart';
import '../widgets/button.dart';
import '../widgets/expandable_bio.dart';
import '../widgets/media_collection.dart';
import '../widgets/profile_icon.dart';
import '../widgets/spotlight_section.dart';
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
    if (_scrollController.offset > AppConstants.appBarFadeScrollOffset &&
        !_showAppBarIcon) {
      setState(() => _showAppBarIcon = true);
    } else if (_scrollController.offset <=
            AppConstants.appBarFadeScrollOffset &&
        _showAppBarIcon) {
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
    // Watch the Provider that now returns an Either<Failure, UserProfile>
    final userProfileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: userProfileAsync.maybeWhen(
        data: (eitherUser) => eitherUser.fold(
          (failure) => _buildFallbackAppBar(context),
          (profile) => _buildAppBar(context, profile),
        ),
        orElse: () => _buildFallbackAppBar(context),
      ),
      body: userProfileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingExtraLarge,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.wifi_off_rounded,
                  color: AppColors.surface,
                  size: AppConstants.errorIconSize,
                ),
                const SizedBox(height: AppConstants.spacingRegular),
                Text(
                  'Oops! Something went wrong.', // Fallback text from feat/prof-state
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppConstants.spacingSmall),
                Text(
                  error.toString().replaceAll(
                        AppConstants.errorExceptionPrefix,
                        '',
                      ),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onPrimary,
                      ),
                ),
                const SizedBox(height: AppConstants.spacingExtraLarge),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.invalidate(userProfileProvider);
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text(AppConstants.tryAgain),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingExtraLarge,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.buttonRadius),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        data: (eitherUser) => eitherUser.fold(
          (failure) => RefreshIndicator(
            onRefresh: () async => ref.read(userProfileProvider.notifier).refreshProfile(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Text(
                    'Could not load profile: ${failure.message}',
                    style: const TextStyle(color: AppColors.onPrimary),
                  ),
                ),
              ),
            ),
          ),
          (user) => RefreshIndicator(
            onRefresh: () async => ref.read(userProfileProvider.notifier).refreshProfile(),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Stack(
                children: [
                  _ProfileCoverPhoto(imageUrl: user.profileDetails.coverPic),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingMedium,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: AppConstants.profileHeaderTopOffset,
                        ),
                        const ProfileIcon(),
                        const SizedBox(height: AppConstants.spacingMedium),
                        UserProfileHeader(user: user),
                        const SizedBox(height: AppConstants.spacingRegular),
                        Consumer(
                          builder: (context, ref, child) {
                            final socialLinks = ref.watch(webProfilesProvider);
                            return ActionButtons(socialLinks: socialLinks);
                          },
                        ),
                        if (user.profileDetails.bio != null) ...[
                          ExpandableBio(bio: user.profileDetails.bio!),
                          const SizedBox(height: AppConstants.spacingSmall),
                        ],
                        const SizedBox(height: AppConstants.spacingRegular),
                        Tile(
                          title: AppConstants.spotlightTitle,
                          subtitle: AppConstants.spotlightSubtitle,
                          buttonText: AppConstants.edit,
                          onButtonPressed: () =>
                              context.push(RoutePaths.editProfile),
                        ),
                        TopTracksSection(userId: user.id),
                        const SizedBox(height: AppConstants.spacingLarge),
                        const MediaCollection(),
                        const SizedBox(height: AppConstants.spacingMassive),
                      ],
                    ),
                  ),
                ],
              ),
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
      leadingWidth: AppConstants.appBarLeadingWidth,
      leading: Button(
        icon: Icons.arrow_back_rounded,
        onPressed: () =>
            context.canPop() ? context.pop() : context.go(RoutePaths.library),
      ),
      centerTitle: true,
      title: AnimatedOpacity(
        opacity: _showAppBarIcon ? 1.0 : 0.0,
        duration: const Duration(
          milliseconds: AppConstants.appBarAnimationDurationMs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppConstants.appBarAvatarSize,
              height: AppConstants.appBarAvatarSize,
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
    // 1. Wrap in a Center so it stays in the middle of wide desktop screens
    return Center(
      // 2. Add ConstrainedBox to stop the extreme horizontal stretching
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900), // Adjust this value to your liking
        child: SizedBox(
          height: AppConstants.coverPhotoHeight,
          width: double.infinity,
          child: imageUrl != null
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  // 3. Add FilterQuality.high for smoother desktop scaling
                  filterQuality: FilterQuality.high, 
                  errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildPlaceholder();
                  },
                )
              : _buildPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surface,
      child: const Icon(
        Icons.image,
        color: AppColors.onPrimary,
        size: AppConstants.placeholderIconSize,
      ),
    );
  }
}