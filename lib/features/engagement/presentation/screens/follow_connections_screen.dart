import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../library_profile/presentation/widgets/pro_badge.dart';
import '../../domain/entities/paginated_engagers.dart';
import '../../domain/entities/track_engager.dart';
import '../providers/follow_connections_provider.dart';
import '../providers/follow_state_provider.dart';

class FollowConnectionsScreen extends ConsumerWidget {
  const FollowConnectionsScreen({
    super.key,
    required this.userId,
    required this.type,
  });

  final int userId;
  final FollowConnectionsType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider).valueOrNull;
    final currentUserId = authState is AuthAuthenticated
        ? authState.user.id
        : null;

    final primaryAsync = ref.watch(
      followConnectionsProvider((userId: userId, type: type)),
    );
    final suggestedAsync = ref.watch(suggestedUsersProvider);

    final primaryTitle = type == FollowConnectionsType.followers
        ? AppConstants.followers
        : AppConstants.following;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
        title: Semantics(
          identifier: 'follow_connections_title',
          label: primaryTitle[0].toUpperCase() + primaryTitle.substring(1),
          container: true,
          child: Text(primaryTitle[0].toUpperCase() + primaryTitle.substring(1)),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(
            followConnectionsProvider((userId: userId, type: type)),
          );
          ref.invalidate(suggestedUsersProvider);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.spacingRegular),
          children: [
            _Section(
              title: primaryTitle,
              data: primaryAsync,
              emptyMessage: 'No $primaryTitle yet',
              itemsAreFollowers: type == FollowConnectionsType.followers,
              currentUserId: currentUserId,
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            _Section(
              title: 'suggested',
              data: suggestedAsync,
              emptyMessage: 'No suggestions right now',
              itemsAreFollowers: false,
              currentUserId: currentUserId,
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.data,
    required this.emptyMessage,
    required this.itemsAreFollowers,
    required this.currentUserId,
  });

  final String title;
  final AsyncValue<PaginatedEngagers> data;
  final String emptyMessage;
  final bool itemsAreFollowers;
  final int? currentUserId;

  @override
  Widget build(BuildContext context) {
    final heading = title[0].toUpperCase() + title.substring(1);

    return Semantics(
      identifier: 'follow_section_${title.replaceAll(' ', '_')}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppConstants.spacingSmall),
        data.when(
          data: (page) {
            if (page.content.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.spacingRegular,
                ),
                child: Text(
                  emptyMessage,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }

            return Column(
              children: page.content
                  .map(
                    (user) => _ConnectionTile(
                      user: user,
                      isFollowerContext: itemsAreFollowers,
                      currentUserId: currentUserId,
                    ),
                  )
                  .toList(),
            );
          },
        loading: () => Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.spacingRegular,
          ),
          child: Center(
            child: Semantics(
              identifier: 'follow_connections_loading',
              label: 'Loading connections',
              child: const CircularProgressIndicator(),
            ),
          ),
        ),
        error: (error, _) => Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.spacingRegular,
          ),
          child: Semantics(
            identifier: 'follow_connections_error',
            label: 'Error: ${error.toString()}',
            child: Text(
              error is NotFoundFailure
                  ? '404 | Not Found'
                  : error.toString().replaceAll('Exception: ', ''),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(
                    color: AppColors.errors,
                    fontWeight: error is NotFoundFailure
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
            ),
          ),
        ),
        ),
        ],
      ),
    );
  }
}

class _ConnectionTile extends ConsumerWidget {
  const _ConnectionTile({
    required this.user,
    required this.isFollowerContext,
    required this.currentUserId,
  });

  final TrackEngager user;
  final bool isFollowerContext;
  final int? currentUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCurrentUser = currentUserId != null && user.id == currentUserId;

    void openProfile() {
      if (isCurrentUser) {
        context.go(RoutePaths.profile);
        return;
      }

      ref.read(followBackHintProvider(user.id).notifier).state =
          isFollowerContext;
      context.push(RoutePaths.publicProfile(user.id.toString()));
    }

    return Semantics(
      identifier: 'connection_tile_${user.id}',
      label: 'User ${user.username}',
      container: true,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: AppConstants.spacingSmall),
        child: Row(
          children: [
            Semantics(
              identifier: 'connection_avatar_${user.id}',
              label: '${user.username}\'s avatar',
              button: true,
              child: GestureDetector(
                onTap: openProfile,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.surface,
                  child: ClipOval(
                    child: user.avatarUrl != null
                        ? CachedNetworkImage(
                            imageUrl: user.avatarUrl!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Icon(
                              Icons.person,
                              color: AppColors.onPrimary,
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.person,
                              color: AppColors.onPrimary,
                            ),
                          )
                        : const Icon(Icons.person, color: AppColors.onPrimary),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.spacingSmall),
            Expanded(
              child: Semantics(
                identifier: 'connection_name_${user.id}',
                label: user.username,
                button: true,
                child: GestureDetector(
                  onTap: openProfile,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          user.username,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                      if (user.tier.toUpperCase() == 'PRO') ...[
                        const SizedBox(width: AppConstants.spacingTiny),
                        const ProBadge(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            if (!isCurrentUser)
              _InlineFollowButton(
                userId: user.id,
                initialIsFollowing: user.isFollowing,
                showFollowBackWhenNotFollowing: isFollowerContext,
              ),
          ],
        ),
      ),
    );
  }
}

class _InlineFollowButton extends ConsumerStatefulWidget {
  const _InlineFollowButton({
    required this.userId,
    required this.initialIsFollowing,
    required this.showFollowBackWhenNotFollowing,
  });

  final int userId;
  final bool initialIsFollowing;
  final bool showFollowBackWhenNotFollowing;

  @override
  ConsumerState<_InlineFollowButton> createState() =>
      _InlineFollowButtonState();
}

class _InlineFollowButtonState extends ConsumerState<_InlineFollowButton> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(followStateProvider(widget.userId).notifier)
          .setInitialState(widget.initialIsFollowing);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFollowing =
        ref.watch(followStateProvider(widget.userId)).valueOrNull ??
        widget.initialIsFollowing;
    final label = isFollowing
        ? 'Following'
        : (widget.showFollowBackWhenNotFollowing ? 'Follow Back' : 'Follow');

    return Semantics(
      identifier: 'inline_follow_button_${widget.userId}',
      label: label,
      button: true,
      child: OutlinedButton(
        onPressed: () {
          ref.read(followStateProvider(widget.userId).notifier).toggleFollow();
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isFollowing ? AppColors.borderLight : AppColors.primary,
          ),
          minimumSize: const Size(0, 32),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isFollowing ? AppColors.onPrimary : AppColors.primary,
            fontSize: AppConstants.fontSizeSmall,
          ),
        ),
      ),
    );
  }
}
