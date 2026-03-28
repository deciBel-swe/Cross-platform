import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/user_profile_provider.dart';
import '../providers/web_profiles_provider.dart';
import '../utils/profile_image_path_utils.dart';
import '../widgets/action_buttons.dart';
import '../widgets/button.dart';
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
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.onPrimary),
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
                      borderRadius: BorderRadius.circular(
                        AppConstants.buttonRadius,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        data: (eitherUser) => eitherUser.fold(
          (failure) => RefreshIndicator(
            onRefresh: () async =>
                ref.read(userProfileProvider.notifier).refreshProfile(),
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
            onRefresh: () async =>
                ref.read(userProfileProvider.notifier).refreshProfile(),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _ProfileCoverPhoto(
                        imageUrl: user.profileDetails.coverPic,
                      ),

                      const Positioned(
                        bottom: -32,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: AppConstants.spacingMedium,
                          ),
                          child: ProfileIcon(),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppConstants.spacingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppConstants.spacingMassive),
                        UserProfileHeader(user: user),
                        Consumer(
                          builder: (context, ref, child) {
                            final socialLinks = ref.watch(webProfilesProvider);
                            return ActionButtons(socialLinks: socialLinks);
                          },
                        ),
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
          mainAxisSize: MainAxisSize.max,
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
            Flexible(
              child: Text(
                user.username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onPrimary,
                ),
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
    bool isDesktop = MediaQuery.sizeOf(context).width > 600;

    double coverHeight = isDesktop ? 350.0 : 160.0;

    return SizedBox(
      height: coverHeight,
      width: double.infinity,
      child: imageUrl == null
          ? _buildPlaceholder()
          : ProfileImagePathUtils.isRemote(imageUrl!)
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _buildPlaceholder();
              },
            )
          : Builder(
              builder: (context) {
                final localPath = ProfileImagePathUtils.localFilePath(
                  imageUrl!,
                );

                if (localPath == null) {
                  return _buildPlaceholder();
                }

                return Image.file(
                  File(localPath),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildPlaceholder(),
                );
              },
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
