import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/subscription_tier_helper.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../engagement/presentation/providers/follow_state_provider.dart';
import '../../../engagement/presentation/widgets/follow_button.dart';
import '../../../library/domain/entities/track.dart';
import '../../../playlists/domain/entities/playlist.dart';
import '../../../playlists/presentation/widgets/playlist_square_card.dart';
import '../../../settings/presentation/providers/blocked_users_provider.dart';
import '../../domain/entities/public_profile.dart';
import '../notifiers/track_notifier.dart';
import '../providers/block_provider.dart';
import '../providers/public_profile_provider.dart';
import '../providers/track_audio_provider.dart';
import '../widgets/expandable_bio.dart';
import '../widgets/playlist_tile.dart';
import '../widgets/pro_badge.dart';
import '../widgets/social_links_widget.dart';
import '../widgets/track_tile.dart';

class PublicProfileScreen extends ConsumerStatefulWidget {
  const PublicProfileScreen({super.key, required this.userIdentifier});

  final String userIdentifier;

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

  Future<bool> _showConfirmDialog(BuildContext context, bool isBlocked) async {
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
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
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
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

  Future<void> _handleModerationAction(
    BuildContext context,
    PublicProfile? profile,
    bool isBlocked,
  ) async {
    if (profile == null) {
      return;
    }

    final confirmed = await _showConfirmDialog(context, isBlocked);
    if (!confirmed || !mounted) {
      return;
    }

    final notifier = ref.read(blockedUsersProvider.notifier);

    try {
      if (isBlocked) {
        await notifier.unblock(profile.id);
        return;
      }

      await notifier.block(
        profile.id,
        username: profile.username,
        avatarUrl: profile.profile?.avatarUrl,
      );

      ref.read(followStateProvider(profile.id).notifier).forceState(false);
      ref.read(followBackHintProvider(profile.id).notifier).state = false;
      ref.invalidate(blockedUsersListProvider);

      if (context.mounted && context.canPop()) {
        context.pop();
      }
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      final cleanMessage = error.toString().replaceFirst('Exception: ', '');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isBlocked
                ? 'Failed to unblock user: $cleanMessage'
                : 'Failed to block user: $cleanMessage',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
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
    final profileAsync = ref.watch(
      publicProfileProvider(widget.userIdentifier),
    );
    final parsedUserId = int.tryParse(widget.userIdentifier);
    final blockedUserIds = ref.watch(blockedUsersProvider);
    final isBlocked =
        parsedUserId != null && blockedUserIds.contains(parsedUserId);

    ref.listen<Set<int>>(blockedUsersProvider, (previous, next) {
      final previousSet = previous ?? <int>{};
      final nextSet = next;

      if (parsedUserId == null) {
        return;
      }

      final wasBlocked = previousSet.contains(parsedUserId);
      final isNowBlocked = nextSet.contains(parsedUserId);

      if (!wasBlocked && isNowBlocked) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User blocked successfully.')),
        );
      } else if (wasBlocked && !isNowBlocked) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User unblocked successfully.')),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, profileAsync, isBlocked),
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

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AsyncValue<PublicProfile> profileAsync,
    bool isBlocked,
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
          onPressed: () {},
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: AppColors.onPrimary),
          color: AppColors.surface,
          onSelected: (_) {
            _handleModerationAction(
              context,
              profileAsync.valueOrNull,
              isBlocked,
            );
          },
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: isBlocked ? 'unblock' : 'block',
              child: Row(
                children: [
                  Icon(
                    isBlocked
                        ? Icons.remove_circle_outline
                        : Icons.block_outlined,
                    color: AppColors.onPrimary,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isBlocked ? 'Unblock' : 'Block',
                    style: const TextStyle(color: AppColors.onPrimary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileBody(BuildContext context, PublicProfile profile) {
    final collectionUsername = _collectionUsername(profile);

    return RefreshIndicator(
      onRefresh: () async => ref
          .read(publicProfileProvider(widget.userIdentifier).notifier)
          .refreshProfile(),
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
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
                    userId: profile.id,
                    userIdentifier: widget.userIdentifier,
                    profile: profile,
                    isActive: _shouldWatchSections,
                    onFollowersTap: () => _openConnections(
                      RoutePaths.publicProfileFollowers(profile.id.toString()),
                    ),
                    onFollowingTap: () => _openConnections(
                      RoutePaths.publicProfileFollowing(profile.id.toString()),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingSmall),
                  _ActionRow(userId: profile.id, profile: profile),
                  const SizedBox(height: AppConstants.spacingRegular),
                  _PublicTrackCollectionSection(
                    title: AppConstants.tracksSectionTitle,
                    tracksAsync: _shouldWatchSections
                        ? ref.watch(userTracksProvider(profile.id))
                        : const AsyncData(<Track>[]),
                    emptyLabel: 'No tracks uploaded yet',
                    errorLabel: 'Could not load tracks',
                  ),
                  const SizedBox(height: AppConstants.spacingLarge),
                  _PublicPlaylistCollectionSection(
                    title: 'Playlists',
                    playlistsAsync: _shouldWatchSections
                        ? ref.watch(publicPlaylistsProvider(collectionUsername))
                        : const AsyncData(<Playlist>[]),
                    emptyLabel: 'No playlists yet.',
                    errorLabel: 'Failed to load playlists.',
                  ),
                  const SizedBox(height: AppConstants.spacingLarge),
                  _PublicLikesCollectionSection(
                    title: 'Likes',
                    tracksAsync: _shouldWatchSections
                        ? ref.watch(
                            publicLikedTracksProvider(collectionUsername),
                          )
                        : const AsyncData(<Track>[]),
                    playlistsAsync: _shouldWatchSections
                        ? ref.watch(
                            publicLikedPlaylistsProvider(collectionUsername),
                          )
                        : const AsyncData(<Playlist>[]),
                    emptyLabel: 'No likes yet',
                    errorLabel: 'Could not load likes',
                  ),
                  const SizedBox(height: AppConstants.spacingLarge),
                  _PublicTrackCollectionSection(
                    title: 'Reposts',
                    tracksAsync: _shouldWatchSections
                        ? ref.watch(
                            publicRepostedTracksProvider(collectionUsername),
                          )
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

  String _collectionUsername(PublicProfile profile) {
    final username = profile.username.trim();
    if (username.isNotEmpty) {
      return username;
    }
    return widget.userIdentifier.trim();
  }

  Widget _buildErrorView(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingExtraLarge,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              error is NotFoundFailure
                  ? Icons.person_off_rounded
                  : error is NetworkFailure
                  ? Icons.cloud_off_rounded
                  : Icons.wifi_off_rounded,
              color: AppColors.surface,
              size: AppConstants.errorIconSize,
            ),
            const SizedBox(height: AppConstants.spacingRegular),
            if (error is! NotFoundFailure && error is! NetworkFailure) ...[
              Text(
                AppConstants.errorGeneric,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.spacingSmall),
            ],
            Text(
              error is NotFoundFailure
                  ? '404 | Not Found'
                  : error is NetworkFailure
                  ? 'You are offline. Downloads are still available from your library.'
                  : error.toString().replaceAll(
                      AppConstants.errorExceptionPrefix,
                      '',
                    ),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onPrimary,
                fontSize: error is NotFoundFailure ? 18 : null,
                fontWeight: error is NotFoundFailure
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            const SizedBox(height: AppConstants.spacingExtraLarge),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.invalidate(publicProfileProvider(widget.userIdentifier)),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(AppConstants.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}

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

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.userId,
    required this.userIdentifier,
    required this.profile,
    required this.isActive,
    required this.onFollowersTap,
    required this.onFollowingTap,
  });

  final int userId;
  final String userIdentifier;
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

        final snapshotAsync = ref.watch(
          publicProfileSnapshotProvider(userIdentifier),
        );
        final snapshot = snapshotAsync.valueOrNull ?? profile;

        final followAsync = ref.watch(followStateProvider(userId));
        final isFollowing = followAsync.valueOrNull ?? snapshot.isFollowing;

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
    final isPremium = SubscriptionTierHelper.isPremium(profile.tier);
    final bio = profile.profile?.bio?.trim() ?? '';
    final location = profile.profile?.location?.trim() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                profile.displayName ?? profile.username,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onPrimary,
                ),
              ),
            ),

            if (isPremium) ...[
              const SizedBox(width: AppConstants.spacingSmall),
              const ProBadge(),
            ],
          ],
        ),
        Text(
          '@${profile.username}',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.onPrimary.withValues(alpha: 0.6),
          ),
        ),
        if (bio.isNotEmpty) ...[
          const SizedBox(height: AppConstants.spacingSmall),
          ExpandableBio(bio: bio),
        ],
        if (location.isNotEmpty) ...[
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            location,
            style: textTheme.bodyMedium?.copyWith(color: AppColors.onPrimary),
          ),
        ],
        const SizedBox(height: AppConstants.spacingSmall),
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

    final isBlocked = ref.watch(blockedUsersProvider).contains(userId);

    return Row(
      children: [
        if (!isOwnProfile) ...[
          if (isBlocked)
            _UnblockButton(userId: userId)
          else
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

class _UnblockButton extends ConsumerStatefulWidget {
  const _UnblockButton({required this.userId});

  final int userId;

  @override
  ConsumerState<_UnblockButton> createState() => _UnblockButtonState();
}

class _UnblockButtonState extends ConsumerState<_UnblockButton> {
  bool _isHovering = false;
  bool _isPressed = false;
  bool _isLoading = false;

  Future<void> _handleUnblock() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(blockedUsersProvider.notifier).unblock(widget.userId);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to unblock: ${e.toString().replaceAll('Exception: ', '')}',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = (_isHovering || _isPressed)
        ? Colors.red.withValues(alpha: 0.15)
        : AppColors.transparent;
    const foregroundColor = Colors.redAccent;
    const borderColor = Colors.redAccent;

    return GestureDetector(
      onTap: _isLoading ? null : _handleUnblock,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 1.2),
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: _isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.redAccent,
                  ),
                )
              : const Text(
                  'Unblock',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: foregroundColor,
                  ),
                ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.canShowAll,
    required this.onShowAll,
  });

  final String title;
  final bool canShowAll;
  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (canShowAll)
          Semantics(
            button: true,
            label: 'See all $title',
            child: TextButton(
              onPressed: onShowAll,
              child: const Text(AppConstants.seeAll),
            ),
          ),
      ],
    );
  }
}

class _PublicTrackCollectionSection extends ConsumerStatefulWidget {
  const _PublicTrackCollectionSection({
    required this.title,
    required this.tracksAsync,
    required this.emptyLabel,
    required this.errorLabel,
  });

  final String title;
  final AsyncValue<List<Track>> tracksAsync;
  final String emptyLabel;
  final String errorLabel;

  @override
  ConsumerState<_PublicTrackCollectionSection> createState() =>
      _PublicTrackCollectionSectionState();
}

class _PublicTrackCollectionSectionState
    extends ConsumerState<_PublicTrackCollectionSection> {
  static const int _pageSize = 3;

  int _visibleCount = _pageSize;

  @override
  void didUpdateWidget(covariant _PublicTrackCollectionSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldTracks = oldWidget.tracksAsync.valueOrNull;
    final newTracks = widget.tracksAsync.valueOrNull;
    if (oldWidget.title != widget.title || !identical(oldTracks, newTracks)) {
      _visibleCount = _pageSize;
    }
  }

  void _showMore(int totalCount) {
    setState(() {
      _visibleCount = math.min(_visibleCount + _pageSize, totalCount);
    });
  }

  void _showAll(int totalCount) {
    setState(() => _visibleCount = totalCount);
  }

  @override
  Widget build(BuildContext context) {
    final tracks = widget.tracksAsync.valueOrNull ?? const <Track>[];
    final canShowAll =
        tracks.length > _pageSize && _visibleCount < tracks.length;

    return Semantics(
      label: '${widget.title} section',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: widget.title,
            canShowAll: canShowAll,
            onShowAll: () => _showAll(tracks.length),
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          widget.tracksAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppConstants.spacingMedium,
              ),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, _) => Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.spacingSmall,
              ),
              child: Text(
                widget.errorLabel,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            data: _buildTrackList,
          ),
        ],
      ),
    );
  }

  Widget _buildTrackList(List<Track> tracks) {
    if (tracks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.spacingSmall,
        ),
        child: Text(
          widget.emptyLabel,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      );
    }

    final visibleCount = math.min(_visibleCount, tracks.length);
    final visibleTracks = tracks.take(visibleCount).toList(growable: false);
    final canShowMore = visibleCount < tracks.length;

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visibleTracks.length,
          itemBuilder: (context, index) {
            final track = visibleTracks[index];
            return Semantics(
              button: true,
              label: 'Play ${track.title} by ${track.artist.username}',
              child: TrackTile(
                track: track,
                onTap: () => ref
                    .read(trackAudioProvider.notifier)
                    .playTrack(track: track, queue: tracks),
              ),
            );
          },
        ),
        if (canShowMore)
          Align(
            alignment: Alignment.center,
            child: Semantics(
              button: true,
              label: 'See more ${widget.title}',
              child: TextButton.icon(
                onPressed: () => _showMore(tracks.length),
                icon: const Icon(Icons.expand_more_rounded),
                label: const Text('See more'),
              ),
            ),
          ),
      ],
    );
  }
}

class _PublicPlaylistCollectionSection extends ConsumerStatefulWidget {
  const _PublicPlaylistCollectionSection({
    required this.title,
    required this.playlistsAsync,
    required this.emptyLabel,
    required this.errorLabel,
  });

  final String title;
  final AsyncValue<List<Playlist>> playlistsAsync;
  final String emptyLabel;
  final String errorLabel;

  @override
  ConsumerState<_PublicPlaylistCollectionSection> createState() =>
      _PublicPlaylistCollectionSectionState();
}

class _PublicPlaylistCollectionSectionState
    extends ConsumerState<_PublicPlaylistCollectionSection> {
  static const int _pageSize = 3;
  int _visibleCount = _pageSize;

  @override
  void didUpdateWidget(covariant _PublicPlaylistCollectionSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldPlaylists = oldWidget.playlistsAsync.valueOrNull;
    final newPlaylists = widget.playlistsAsync.valueOrNull;
    if (oldWidget.title != widget.title ||
        !identical(oldPlaylists, newPlaylists)) {
      _visibleCount = _pageSize;
    }
  }

  void _showAll(int totalCount) {
    setState(() => _visibleCount = totalCount);
  }

  void _showMore(int totalCount) {
    setState(() {
      _visibleCount = math.min(_visibleCount + _pageSize, totalCount);
    });
  }

  @override
  Widget build(BuildContext context) {
    final playlists = widget.playlistsAsync.valueOrNull ?? const <Playlist>[];
    final canShowAll =
        playlists.length > _pageSize && _visibleCount < playlists.length;

    return Semantics(
      label: '${widget.title} section',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: widget.title,
            canShowAll: canShowAll,
            onShowAll: () => _showAll(playlists.length),
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          widget.playlistsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppConstants.spacingMedium,
              ),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, _) => Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.spacingSmall,
              ),
              child: Text(
                widget.errorLabel,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            data: _buildPlaylistList,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistList(List<Playlist> playlists) {
    if (playlists.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.spacingSmall,
        ),
        child: Text(
          widget.emptyLabel,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      );
    }

    final visibleCount = math.min(_visibleCount, playlists.length);
    final visiblePlaylists = playlists
        .take(visibleCount)
        .toList(growable: false);
    final canShowMore = visibleCount < playlists.length;

    return Column(
      children: [
        SizedBox(
          height: 184,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: visiblePlaylists.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppConstants.spacingSmall),
            itemBuilder: (context, index) {
              final playlist = visiblePlaylists[index];
              return Semantics(
                button: true,
                label: 'Open playlist ${playlist.title}',
                child: PlaylistSquareCard(
                  playlist: playlist,
                  onTap: () {
                    context.push(RoutePaths.playlistTracks, extra: playlist);
                  },
                ),
              );
            },
          ),
        ),
        if (canShowMore)
          Align(
            alignment: Alignment.center,
            child: Semantics(
              button: true,
              label: 'See more ${widget.title}',
              child: TextButton.icon(
                onPressed: () => _showMore(playlists.length),
                icon: const Icon(Icons.expand_more_rounded),
                label: const Text('See more'),
              ),
            ),
          ),
      ],
    );
  }
}

class _PublicLikesCollectionSection extends ConsumerStatefulWidget {
  const _PublicLikesCollectionSection({
    required this.title,
    required this.tracksAsync,
    required this.playlistsAsync,
    required this.emptyLabel,
    required this.errorLabel,
  });

  final String title;
  final AsyncValue<List<Track>> tracksAsync;
  final AsyncValue<List<Playlist>> playlistsAsync;
  final String emptyLabel;
  final String errorLabel;

  @override
  ConsumerState<_PublicLikesCollectionSection> createState() =>
      _PublicLikesCollectionSectionState();
}

class _PublicLikesCollectionSectionState
    extends ConsumerState<_PublicLikesCollectionSection> {
  static const int _pageSize = 3;
  int _visibleCount = _pageSize;

  @override
  void didUpdateWidget(covariant _PublicLikesCollectionSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldTracks = oldWidget.tracksAsync.valueOrNull;
    final newTracks = widget.tracksAsync.valueOrNull;
    final oldPlaylists = oldWidget.playlistsAsync.valueOrNull;
    final newPlaylists = widget.playlistsAsync.valueOrNull;

    if (oldWidget.title != widget.title ||
        !identical(oldTracks, newTracks) ||
        !identical(oldPlaylists, newPlaylists)) {
      _visibleCount = _pageSize;
    }
  }

  void _showMore(int totalCount) {
    setState(() {
      _visibleCount = math.min(_visibleCount + _pageSize, totalCount);
    });
  }

  void _showAll(int totalCount) {
    setState(() => _visibleCount = totalCount);
  }

  @override
  Widget build(BuildContext context) {
    final tracks = widget.tracksAsync.valueOrNull ?? const <Track>[];
    final playlists = widget.playlistsAsync.valueOrNull ?? const <Playlist>[];
    final combined = [...tracks, ...playlists];

    final canShowAll =
        combined.length > _pageSize && _visibleCount < combined.length;

    return Semantics(
      label: '${widget.title} section',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: widget.title,
            canShowAll: canShowAll,
            onShowAll: () => _showAll(combined.length),
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          if (widget.tracksAsync.isLoading || widget.playlistsAsync.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppConstants.spacingMedium,
              ),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (widget.tracksAsync.hasError || widget.playlistsAsync.hasError)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.spacingSmall,
              ),
              child: Text(
                widget.errorLabel,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            )
          else
            _buildCombinedList(combined),
        ],
      ),
    );
  }

  Widget _buildCombinedList(List<Object> items) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.spacingSmall,
        ),
        child: Text(
          widget.emptyLabel,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      );
    }

    final visibleCount = math.min(_visibleCount, items.length);
    final visibleItems = items.take(visibleCount).toList(growable: false);
    final canShowMore = visibleCount < items.length;

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visibleItems.length,
          itemBuilder: (context, index) {
            final item = visibleItems[index];
            if (item is Track) {
              return Semantics(
                button: true,
                label: 'Play ${item.title} by ${item.artist.username}',
                child: TrackTile(
                  track: item,
                  onTap: () {
                    final allTracks = items.whereType<Track>().toList();
                    ref
                        .read(trackAudioProvider.notifier)
                        .playTrack(track: item, queue: allTracks);
                  },
                ),
              );
            } else if (item is Playlist) {
              return Semantics(
                button: true,
                label: 'Open playlist ${item.title}',
                child: PlaylistTile(
                  playlist: item,
                  onTap: () {
                    context.push(RoutePaths.playlistTracks, extra: item);
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        if (canShowMore)
          Align(
            alignment: Alignment.center,
            child: Semantics(
              button: true,
              label: 'See more ${widget.title}',
              child: TextButton.icon(
                onPressed: () => _showMore(items.length),
                icon: const Icon(Icons.expand_more_rounded),
                label: const Text('See more'),
              ),
            ),
          ),
      ],
    );
  }
}
