import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/track_engager.dart';
import '../notifiers/track_engagers_notifier.dart';

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
          Text(
            widget.type == EngagerType.likers ? 'Likes' : 'Reposts',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Colors.white12),
          Expanded(
            child: engagersAsync.when(
              data: (paginated) => paginated.content.isEmpty
                  ? _buildEmptyState()
                  : _buildList(paginated.content, paginated.isLast),
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (error, _) => _buildErrorState(error.toString()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<TrackEngager> engagers, bool isLast) {
    return ListView.separated(
      controller: widget.scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: engagers.length + (isLast ? 0 : 1),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index < engagers.length) {
          return _EngagerTile(user: engagers[index]);
        } else {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.errors),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            TextButton(
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
          ],
        ),
      ),
    );
  }
}

class _EngagerTile extends StatelessWidget {
  const _EngagerTile({required this.user});

  final TrackEngager user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white10,
            backgroundImage: user.avatarUrl != null
                ? NetworkImage(user.avatarUrl!)
                : null,
            child: user.avatarUrl == null
                ? const Icon(Icons.person, color: Colors.white54)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.username,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
          _FollowButton(isFollowing: user.isFollowing),
        ],
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

class _FollowButton extends StatefulWidget {
  const _FollowButton({required this.isFollowing});

  final bool isFollowing;

  @override
  State<_FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<_FollowButton> {
  late bool _isFollowing;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.isFollowing;
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _isFollowing = !_isFollowing;
        });
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: _isFollowing ? Colors.white24 : AppColors.primary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        minimumSize: const Size(0, 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(
        _isFollowing ? 'Following' : 'Follow',
        style: TextStyle(
          color: _isFollowing ? Colors.white70 : AppColors.primary,
          fontSize: 12,
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
