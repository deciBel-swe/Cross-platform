import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/public_profile.dart';
import '../../../engagement/presentation/providers/follow_state_provider.dart';
import '../../../engagement/presentation/widgets/follow_button.dart';
import '../providers/public_profile_provider.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/expandable_bio.dart';
import '../widgets/social_links_widget.dart';
import '../widgets/spotlight_section.dart';

/// Screen that displays another user's public profile.
///
/// Fetches data from `GET /users/{userId}` via [publicProfileProvider] and
/// shows the user's bio, stats, social links, and top tracks. Includes a
/// [FollowButton] that is hidden when viewing the logged-in user's own
/// profile.
///
/// Navigated to via `context.push(RoutePaths.publicProfile(userId))`.
class PublicProfileScreen extends ConsumerStatefulWidget {
  const PublicProfileScreen({super.key, required this.userId});

  /// The ID of the user whose public profile to display.
  final int userId;

  @override
  ConsumerState<PublicProfileScreen> createState() =>
      _PublicProfileScreenState();
}

class _PublicProfileScreenState extends ConsumerState<PublicProfileScreen> {
  late ScrollController _scrollController;
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  /// Shows/hides the app bar title based on scroll position.
  void _onScroll() {
    if (_scrollController.offset > AppConstants.appBarFadeScrollOffset &&
        !_showAppBarTitle) {
      setState(() => _showAppBarTitle = true);
    } else if (_scrollController.offset <=
            AppConstants.appBarFadeScrollOffset &&
        _showAppBarTitle) {
      setState(() => _showAppBarTitle = false);
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
    final profileAsync = ref.watch(publicProfileProvider(widget.userId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, profileAsync),
      body: profileAsync.when(
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stack) {
          return _buildErrorView(context, error);
        },
        data: (profile) {
          return _buildProfileBody(context, profile);
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // App Bar
  // ---------------------------------------------------------------------------

  /// Builds the app bar with a back button and an animated title
  /// that fades in when the user scrolls past the profile header.
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AsyncValue<PublicProfile> profileAsync,
  ) {
    final username = profileAsync.valueOrNull?.username ?? '';

    return AppBar(
      backgroundColor: AppColors.background,
      scrolledUnderElevation: 0,
      surfaceTintColor: AppColors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onPrimary),
        onPressed: () =>
            context.canPop() ? context.pop() : context.go('/home'),
      ),
      centerTitle: true,
      title: AnimatedOpacity(
        opacity: _showAppBarTitle ? 1.0 : 0.0,
        duration: const Duration(
          milliseconds: AppConstants.appBarAnimationDurationMs,
        ),
        child: Text(
          username,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onPrimary,
              ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: AppColors.onPrimary),
          onPressed: () {
            // TODO: share profile action
          },
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Profile Body
  // ---------------------------------------------------------------------------

  /// Builds the scrollable profile body: cover photo, avatar, header,
  /// follow button, bio, stats, social links, and top tracks.
  Widget _buildProfileBody(BuildContext context, PublicProfile profile) {
    return RefreshIndicator(
      onRefresh: () async => ref
          .read(publicProfileProvider(widget.userId).notifier)
          .refreshProfile(),
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Cover photo + avatar stack
            Stack(
              clipBehavior: Clip.none,
              children: [
                _CoverPhoto(imageUrl: profile.profile?.coverPhotoUrl),
                Positioned(
                  bottom: -40,
                  left: AppConstants.spacingMedium,
                  child: _Avatar(imageUrl: profile.profile?.avatarUrl),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppConstants.spacingMassive),
                  _ProfileHeader(profile: profile),
                  const SizedBox(height: AppConstants.spacingSmall),
                  _ActionRow(
                    userId: widget.userId,
                    profile: profile,
                  ),
                  const SizedBox(height: AppConstants.spacingRegular),
                  TopTracksSection(userId: profile.id),
                  const SizedBox(height: AppConstants.spacingMassive),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Error View
  // ---------------------------------------------------------------------------

  /// Displays a full-screen error state with a retry button.
  Widget _buildErrorView(BuildContext context, Object error) {
    return Center(
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
              AppConstants.errorGeneric,
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
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.onPrimary),
            ),
            const SizedBox(height: AppConstants.spacingExtraLarge),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(
                publicProfileProvider(widget.userId),
              ),
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
    );
  }
}

// =============================================================================
// Private Widgets
// =============================================================================

/// Displays the profile cover photo or a dark placeholder.
class _CoverPhoto extends StatelessWidget {
  const _CoverPhoto({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > 600;
    final coverHeight = isDesktop ? 350.0 : 160.0;

    return SizedBox(
      height: coverHeight,
      width: double.infinity,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              errorBuilder: (_, _, _) => _placeholder(),
              loadingBuilder: (_, child, progress) =>
                  progress == null ? child : _placeholder(),
            )
          : _placeholder(),
    );
  }

  Widget _placeholder() {
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

/// Circular avatar with a border ring.
class _Avatar extends StatelessWidget {
  const _Avatar({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.background, width: 3),
        color: AppColors.surface,
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _avatarPlaceholder(),
              )
            : _avatarPlaceholder(),
      ),
    );
  }

  Widget _avatarPlaceholder() {
    return const Icon(
      Icons.person,
      size: 40,
      color: AppColors.textMuted,
    );
  }
}

/// Username, bio, location, and follower/following counts.
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final PublicProfile profile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bio = profile.profile?.bio?.trim() ?? '';
    final location = profile.profile?.location?.trim() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Username
        Text(
          profile.username,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onPrimary,
          ),
        ),
        // Bio
        if (bio.isNotEmpty) ...[
          const SizedBox(height: AppConstants.spacingSmall),
          ExpandableBio(bio: bio),
        ],
        // Location
        if (location.isNotEmpty) ...[
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            location,
            style: textTheme.bodyMedium?.copyWith(color: AppColors.onPrimary),
          ),
        ],
        const SizedBox(height: AppConstants.spacingSmall),
        // Stats row
        Row(
          children: [
            _StatChip(
              count: profile.stats.followersCount,
              label: AppConstants.followers,
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
            _StatChip(
              count: profile.stats.followingCount,
              label: AppConstants.following,
            ),
          ],
        ),
      ],
    );
  }
}

/// Displays a single stat as "123 followers".
class _StatChip extends StatelessWidget {
  const _StatChip({required this.count, required this.label});

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: AppColors.onPrimary),
        children: [
          TextSpan(
            text: '$count ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: label),
        ],
      ),
    );
  }
}

/// Row containing the [FollowButton] and social links.
///
/// Hides the follow button when the profile belongs to the currently
/// logged-in user.
class _ActionRow extends ConsumerWidget {
  const _ActionRow({
    required this.userId,
    required this.profile,
  });

  final int userId;
  final PublicProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine if this is the logged-in user's own profile.
    final ownProfileAsync = ref.watch(userProfileProvider);
    final isOwnProfile = ownProfileAsync.maybeWhen(
      data: (eitherUser) => eitherUser.fold(
        (_) => false,
        (user) => user.id == userId,
      ),
      orElse: () => false,
    );

    // Watch the follow state to update follower count optimistically.
    final followAsync = ref.watch(followStateProvider(userId));
    final isFollowing = followAsync.valueOrNull ?? profile.isFollowing;

    // Adjust follower count optimistically based on follow toggle.
    final followerDelta = isFollowing != profile.isFollowing
        ? (isFollowing ? 1 : -1)
        : 0;
    final adjustedFollowers = profile.stats.followersCount + followerDelta;

    return Row(
      children: [
        if (!isOwnProfile) ...[
          FollowButton(
            userId: userId,
            isFollowedBy: profile.isFollowedBy,
          ),
          const SizedBox(width: AppConstants.spacingSmall),
        ],
        if (profile.socialLinks != null)
          SocialLinksWidget(socialLinks: profile.socialLinks!),
        const Spacer(),
        // Show adjusted follower count if it differs
        if (followerDelta != 0)
          Padding(
            padding: const EdgeInsets.only(right: AppConstants.spacingSmall),
            child: Text(
              '$adjustedFollowers ${AppConstants.followers}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
      ],
    );
  }
}
