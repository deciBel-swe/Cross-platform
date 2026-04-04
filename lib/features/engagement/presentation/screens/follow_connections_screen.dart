import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
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
        title: Text(
          primaryTitle[0].toUpperCase() + primaryTitle.substring(1),
          style: const TextStyle(color: AppColors.onPrimary),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(followConnectionsProvider((userId: userId, type: type)));
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
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            _Section(
              title: 'suggested',
              data: suggestedAsync,
              emptyMessage: 'No suggestions right now',
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
  });

  final String title;
  final AsyncValue<PaginatedEngagers> data;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final heading = title[0].toUpperCase() + title.substring(1);

    return Column(
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
                  .map((user) => _ConnectionTile(user: user))
                  .toList(),
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: AppConstants.spacingRegular),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppConstants.spacingRegular,
            ),
            child: Text(
              error.toString().replaceAll('Exception: ', ''),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.errors,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ConnectionTile extends StatelessWidget {
  const _ConnectionTile({required this.user});

  final TrackEngager user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingSmall),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.push(RoutePaths.publicProfile(user.id)),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.surface,
              backgroundImage: user.avatarUrl != null
                  ? NetworkImage(user.avatarUrl!)
                  : null,
              child: user.avatarUrl == null
                  ? const Icon(Icons.person, color: AppColors.onPrimary)
                  : null,
            ),
          ),
          const SizedBox(width: AppConstants.spacingSmall),
          Expanded(
            child: GestureDetector(
              onTap: () => context.push(RoutePaths.publicProfile(user.id)),
              behavior: HitTestBehavior.opaque,
              child: Text(
                user.username,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          _InlineFollowButton(
            userId: user.id,
            initialIsFollowing: user.isFollowing,
          ),
        ],
      ),
    );
  }
}

class _InlineFollowButton extends ConsumerStatefulWidget {
  const _InlineFollowButton({
    required this.userId,
    required this.initialIsFollowing,
  });

  final int userId;
  final bool initialIsFollowing;

  @override
  ConsumerState<_InlineFollowButton> createState() => _InlineFollowButtonState();
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

    return OutlinedButton(
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
        isFollowing ? 'Following' : 'Follow',
        style: TextStyle(
          color: isFollowing ? AppColors.onPrimary : AppColors.primary,
          fontSize: AppConstants.fontSizeSmall,
        ),
      ),
    );
  }
}
