import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../engagement/presentation/providers/follow_state_provider.dart';
import '../../../engagement/presentation/widgets/follow_button.dart';
import '../../../library/domain/entities/track.dart';
import '../../domain/entities/public_profile.dart';
import '../providers/public_profile_provider.dart';
import '../widgets/expandable_bio.dart';
import '../widgets/social_links_widget.dart';
import '../widgets/spotlight_section.dart';
import '../widgets/track_tile.dart';

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
  bool _shouldWatchSections = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _openConnections(String route) async {
    if (_shouldWatchSections) {
      setState(() => _shouldWatchSections = false);
      await Future<void>.delayed(Duration.zero);
      if (!mounted) {
        return;
      }
    }

    await context.push(route);

    if (mounted) {
      setState(() => _shouldWatchSections = true);
    }
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
        onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
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
                  _ProfileHeader(
                    userId: widget.userId,
                    profile: profile,
                    isActive: _shouldWatchSections,
                    onFollowersTap: () => _openConnections(
                      RoutePaths.publicProfileFollowers(widget.userId),
                    ),
                    onFollowingTap: () => _openConnections(
                      RoutePaths.publicProfileFollowing(widget.userId),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingSmall),
                  _ActionRow(userId: widget.userId, profile: profile),
                  const SizedBox(height: AppConstants.spacingRegular),
                  const _SectionTitle(title: AppConstants.tracksSectionTitle),
                  const SizedBox(height: AppConstants.spacingSmall),
                  TopTracksSection(userId: profile.id),
                  const SizedBox(height: AppConstants.spacingLarge),
                  const _SectionTitle(title: 'Likes'),
                  const SizedBox(height: AppConstants.spacingSmall),
                  _PublicTrackCollectionSection(
                    tracksAsync: _shouldWatchSections
                        ? ref.watch(publicLikedTracksProvider(profile.id))
                        : const AsyncData(<Track>[]),
                    emptyLabel: 'No likes yet',
                    errorLabel: 'Could not load likes',
                  ),
                  const SizedBox(height: AppConstants.spacingLarge),
                  const _SectionTitle(title: 'Reposts'),
                  const SizedBox(height: AppConstants.spacingSmall),
                  _PublicTrackCollectionSection(
                    tracksAsync: _shouldWatchSections
                        ? ref.watch(publicRepostedTracksProvider(profile.id))
                        : const AsyncData(<Track>[]),
                    emptyLabel: 'No reposts yet',
                    errorLabel: 'Could not load reposts',
                  ),
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
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.onPrimary),
            ),
            const SizedBox(height: AppConstants.spacingExtraLarge),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.invalidate(publicProfileProvider(widget.userId)),
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
          ? CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              placeholder: (_, _) => _placeholder(),
              errorWidget: (_, _, _) => _placeholder(),
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
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (_, _) => _avatarPlaceholder(),
                errorWidget: (_, _, _) => _avatarPlaceholder(),
              )
            : _avatarPlaceholder(),
      ),
    );
  }

  Widget _avatarPlaceholder() {
    return const Icon(Icons.person, size: 40, color: AppColors.textMuted);
  }
}

/// Username, bio, location, and follower/following counts.
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.userId,
    required this.profile,
    required this.isActive,
    required this.onFollowersTap,
    required this.onFollowingTap,
  });

  final int userId;
  final PublicProfile profile;
  final bool isActive;
  final VoidCallback onFollowersTap;
  final VoidCallback onFollowingTap;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        if (!isActive) {
          return _ProfileHeaderContent(
            userId: userId,
            profile: profile,
            followersCount: profile.stats.followersCount,
            onFollowersTap: onFollowersTap,
            onFollowingTap: onFollowingTap,
          );
        }

        final snapshotAsync = ref.watch(publicProfileSnapshotProvider(userId));
        final snapshot = snapshotAsync.valueOrNull ?? profile;

        final followAsync = ref.watch(followStateProvider(userId));
        final isFollowing = followAsync.valueOrNull ?? snapshot.isFollowing;

        // Avoid double counting: once snapshot is available, trust backend count.
        // Apply local delta only while still showing the initial profile fallback.
        final shouldApplyLocalDelta = snapshotAsync.valueOrNull == null;
        final followerDelta = shouldApplyLocalDelta
            ? (isFollowing != profile.isFollowing ? (isFollowing ? 1 : -1) : 0)
            : 0;

        final displayedFollowers = math.max(
          snapshot.stats.followersCount + followerDelta,
          0,
        );

        return _ProfileHeaderContent(
          userId: userId,
          profile: snapshot,
          followersCount: displayedFollowers,
          onFollowersTap: onFollowersTap,
          onFollowingTap: onFollowingTap,
        );
      },
    );
  }
}

class _ProfileHeaderContent extends StatelessWidget {
  const _ProfileHeaderContent({
    required this.userId,
    required this.profile,
    required this.followersCount,
    required this.onFollowersTap,
    required this.onFollowingTap,
  });

  final int userId;
  final PublicProfile profile;
  final int followersCount;
  final VoidCallback onFollowersTap;
  final VoidCallback onFollowingTap;

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
              count: followersCount,
              label: AppConstants.followers,
              onTap: onFollowersTap,
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
              onTap: onFollowingTap,
            ),
          ],
        ),
      ],
    );
  }
}

/// Displays a single stat as "123 followers".
class _StatChip extends StatelessWidget {
  const _StatChip({
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
    );
  }
}

/// Row containing the [FollowButton] and social links.
///
/// Hides the follow button when the profile belongs to the currently
/// logged-in user.
class _ActionRow extends ConsumerWidget {
  const _ActionRow({required this.userId, required this.profile});

  final int userId;
  final PublicProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider).valueOrNull;
    final isOwnProfile =
        authState is AuthAuthenticated && authState.user.id == userId;

    final followBackHint = ref.watch(followBackHintProvider(userId));
    final isFollowedBy = profile.isFollowedBy || followBackHint;

    return Row(
      children: [
        if (!isOwnProfile) ...[
          FollowButton(userId: userId, isFollowedBy: isFollowedBy),
          const SizedBox(width: AppConstants.spacingSmall),
        ],
        if (profile.socialLinks != null)
          SocialLinksWidget(socialLinks: profile.socialLinks!),
        const Spacer(),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _PublicTrackCollectionSection extends StatelessWidget {
  const _PublicTrackCollectionSection({
    required this.tracksAsync,
    required this.emptyLabel,
    required this.errorLabel,
  });

  final AsyncValue<List<Track>> tracksAsync;
  final String emptyLabel;
  final String errorLabel;

  @override
  Widget build(BuildContext context) {
    return tracksAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppConstants.spacingMedium),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.spacingSmall,
        ),
        child: Text(
          errorLabel,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ),
      data: (tracks) {
        if (tracks.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppConstants.spacingSmall,
            ),
            child: Text(
              emptyLabel,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tracks.length,
          itemBuilder: (context, index) {
            final track = tracks[index];
            return TrackTile(
              track: track,
              onTap: () => context.push(RoutePaths.trackPreview(track.id)),
            );
          },
        );
      },
    );
  }
}
