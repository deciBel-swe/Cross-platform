import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/track_engager.dart';
import '../notifiers/track_engagers_notifier.dart';
import '../providers/follow_state_provider.dart';

class TrackEngagersBottomSheet extends ConsumerStatefulWidget {
  const TrackEngagersBottomSheet({
    super.key,
    required this.trackId,
    required this.type,
    required this.scrollController,
  });

  final int trackId;
  final EngagerType type;
  final ScrollController scrollController;

  @override
  ConsumerState<TrackEngagersBottomSheet> createState() =>
      _TrackEngagersBottomSheetState();
}

class _TrackEngagersBottomSheetState
    extends ConsumerState<TrackEngagersBottomSheet> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent - 200) {
      ref
          .read(
            trackEngagersProvider((
              trackId: widget.trackId,
              type: widget.type,
            )).notifier,
          )
          .loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final engagersAsync = ref.watch(
      trackEngagersProvider((trackId: widget.trackId, type: widget.type)),
    );

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Semantics(
            identifier: 'track_engagers_title',
            label: widget.type == EngagerType.likers ? 'Likes' : 'Reposts',
            container: true,
            child: Text(
              widget.type == EngagerType.likers ? 'Likes' : 'Reposts',
              style: AppTextStyles.sectionTitle,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Colors.white12),
          Expanded(
            child: engagersAsync.when(
              data: (paginated) => paginated.content.isEmpty
                  ? _buildEmptyState()
                  : _buildList(paginated.content, paginated.isLast),
              loading: () => Center(
                child: Semantics(
                  identifier: 'track_engagers_loading',
                  label: 'Loading engagers',
                  child: const CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              ),
              error: (error, _) => _buildErrorState(error.toString()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<TrackEngager> engagers, bool isLast) {
    return Semantics(
      identifier: 'track_engagers_list',
      child: ListView.separated(
        controller: widget.scrollController,
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: engagers.length + (isLast ? 0 : 1),
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index < engagers.length) {
            return _EngagerTile(user: engagers[index]);
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Semantics(
                  identifier: 'track_engagers_load_more',
                  label: 'Loading more',
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Semantics(
      identifier: 'track_engagers_empty_state',
      label: widget.type == EngagerType.likers
          ? 'No likes yet'
          : 'No reposts yet',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline, size: 48, color: Colors.white24),
            const SizedBox(height: 16),
            Text(
              widget.type == EngagerType.likers
                  ? 'No likes yet'
                  : 'No reposts yet',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    final message = error is NotFoundFailure
        ? '404 | Not Found'
        : error.toString().replaceAll('Exception: ', '');

    return Semantics(
      identifier: 'track_engagers_error_state',
      label: 'Error loading engagers: $message',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.errors,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Semantics(
                identifier: 'track_engagers_retry_button',
                button: true,
                child: TextButton(
                  onPressed: () => ref.invalidate(
                    trackEngagersProvider((
                      trackId: widget.trackId,
                      type: widget.type,
                    )),
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EngagerTile extends ConsumerWidget {
  const _EngagerTile({required this.user});

  final TrackEngager user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider).valueOrNull;
    final isAuthenticated = authState is AuthAuthenticated;
    final isOwnProfile = isAuthenticated && authState.user.id == user.id;

    return Semantics(
      identifier: 'engager_tile_${user.id}',
      label: 'User ${user.displayName ?? user.username}',
      container: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Semantics(
              identifier: 'engager_avatar_${user.id}',
              label: '${user.displayName ?? user.username}\'s avatar',
              button: true,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  context.go(RoutePaths.publicProfile(user.username));
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white10,
                  backgroundImage: user.avatarUrl != null
                      ? CachedNetworkImageProvider(user.avatarUrl!)
                      : null,
                  child: user.avatarUrl == null
                      ? const Icon(Icons.person, color: Colors.white54)
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Semantics(
                identifier: 'engager_name_${user.id}',
                label: user.displayName ?? user.username,
                button: true,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    context.go(RoutePaths.publicProfile(user.username));
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              (user.displayName?.isNotEmpty == true)
                                  ? user.displayName!
                                  : user.username,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          if (user.tier == 'PRO') ...[
                            const SizedBox(width: 4),
                            const _ProBadge(),
                          ],
                        ],
                      ),
                      Text(
                        'Artist', // Placeholder for now
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isAuthenticated && !isOwnProfile)
              _FollowButton(
                userId: user.id,
                initialFollowing: user.isFollowing,
              ),
          ],
        ),
      ),
    );
  }
}

class _ProBadge extends StatelessWidget {
  const _ProBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(2),
      ),
      child: const Text(
        'PRO',
        style: TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _FollowButton extends ConsumerStatefulWidget {
  const _FollowButton({required this.userId, required this.initialFollowing});

  final int userId;
  final bool initialFollowing;

  @override
  ConsumerState<_FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends ConsumerState<_FollowButton> {
  @override
  void initState() {
    super.initState();
    // Synchronize the global follow state with the search result item.
    // If we already have a newer state for this user globally, this call
    // will be ignored by the notifier if it's already set.
    Future.microtask(() {
      ref
          .read(followStateProvider(widget.userId).notifier)
          .setInitialState(widget.initialFollowing);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the global follow state for this user.
    final isFollowing =
        ref.watch(followStateProvider(widget.userId)).valueOrNull ??
        widget.initialFollowing;

    return Semantics(
      identifier: 'follow_button_${widget.userId}',
      label: isFollowing ? 'Following' : 'Follow',
      button: true,
      child: OutlinedButton(
        onPressed: () {
          ref.read(followStateProvider(widget.userId).notifier).toggleFollow();
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isFollowing ? Colors.white24 : AppColors.primary,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          minimumSize: const Size(0, 32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Text(
          isFollowing ? 'Following' : 'Follow',
          style: TextStyle(
            color: isFollowing ? Colors.white70 : AppColors.primary,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

void showTrackEngagersSheet(
  BuildContext context, {
  required int trackId,
  required EngagerType type,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => TrackEngagersBottomSheet(
        trackId: trackId,
        type: type,
        scrollController: scrollController,
      ),
    ),
  );
}
