import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/moderation_provider.dart';
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
  const ProfileScreen({super.key, this.userId});

  final int? userId;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late ScrollController _scrollController;
  bool _showAppBarIcon = false;

  bool get _isPublicProfile => widget.userId != null;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  Future<bool> _showConfirmDialog(BuildContext context, bool isBlocked) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: const Color(0xFF2B2B2B),
            title: Text(
              isBlocked ? 'Unblock user?' : 'Block user?',
              style: const TextStyle(color: Colors.white),
            ),
            content: Text(
              isBlocked
                  ? "They will now be able to follow and interact with you and your content. We won't let them know that you have unblocked them."
                  : 'This user will no longer be able to follow or interact with you, and you will not see notifications from them.',
              style: const TextStyle(color: Colors.white70, height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  isBlocked ? 'UNBLOCK' : 'BLOCK',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _showModerationSheet(
    BuildContext context,
    UserProfile user,
  ) async {
    final moderationState = ref.read(moderationProvider);
    final bool isBlocked = moderationState.value?.contains(user.id) ?? false;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Icon(
                    isBlocked
                        ? Icons.remove_circle_outline
                        : Icons.block_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                  title: Text(
                    isBlocked ? 'Unblock user' : 'Block user',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(sheetContext);

                    final confirmed = await _showConfirmDialog(
                      context,
                      isBlocked,
                    );
                    if (!confirmed || !context.mounted) {
                      return;
                    }

                    if (isBlocked) {
                      await ref
                          .read(moderationProvider.notifier)
                          .unblockUser(user.id);
                    } else {
                      await ref
                          .read(moderationProvider.notifier)
                          .blockUser(user.id);

                      if (context.mounted && context.canPop()) {
                        context.pop();
                      }
                    }
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
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
    final userProfileAsync = ref.watch(userProfileProvider);

    ref.listen<AsyncValue<Set<int>>>(moderationProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update moderation status.')),
        );
      }
    });

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
                  'Oops! Something went wrong.',
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
                        UserProfileHeader(
                          user: user,
                          onFollowersTap: () => context.push(
                            RoutePaths.profileFollowers,
                            extra: user.id,
                          ),
                          onFollowingTap: () => context.push(
                            RoutePaths.profileFollowing,
                            extra: user.id,
                          ),
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            final socialLinks = ref.watch(webProfilesProvider);
                            return ActionButtons(socialLinks: socialLinks);
                          },
                        ),
                        const SizedBox(height: AppConstants.spacingRegular),
                        Tile(
                          title: AppConstants.tracksSectionTitle,
                          subtitle: AppConstants.tracksSectionSubtitle,
                          buttonText: AppConstants.seeAll,
                          onButtonPressed: () =>
                              context.push(RoutePaths.uploadLibrary),
                        ),
                        TopTracksSection(userId: user.id),
                        const SizedBox(height: AppConstants.spacingLarge),
                        if (!_isPublicProfile) const MediaCollection(),
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
        if (_isPublicProfile)
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showModerationSheet(context, user),
          ),
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
    final bool isDesktop = MediaQuery.sizeOf(context).width > 600;
    final double coverHeight = isDesktop ? 350.0 : 160.0;

    return Container(
      height: coverHeight,
      width: double.infinity,
      color: AppColors.surface,
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

