import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/decibel_cached_image.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../providers/history_provider.dart';

/// Home rail showing the latest tracks from listening history.
class RecentlyPlayedSection extends ConsumerWidget {
  const RecentlyPlayedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return historyAsync.when(
      loading: () => Semantics(
        label: 'Loading recently played tracks',
        child: const SizedBox(
          height: 172,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, _) => _HistoryPreviewError(message: error.toString()),
      data: (history) {
        final tracks = history.tracks.take(10).toList(growable: false);
        if (tracks.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitleRow(
              title: 'Recently played',
              onSeeAll: () => context.push(RoutePaths.recentlyPlayed),
            ),
            const SizedBox(height: AppDimensions.paddingSm),
            SizedBox(
              height: 168,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: tracks.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppDimensions.paddingMd),
                itemBuilder: (context, index) {
                  final track = tracks[index];
                  return _RecentlyPlayedCard(
                    track: track,
                    onTap: () =>
                        _playTrack(context, ref, track, history.tracks),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _playTrack(
    BuildContext context,
    WidgetRef ref,
    Track track,
    List<Track> queue,
  ) async {
    if (!track.isPlayable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This track is not available for playback.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    await ref
        .read(trackAudioProvider.notifier)
        .playTrack(track: track, queue: queue, autoPlay: true);
  }
}

class _SectionTitleRow extends StatelessWidget {
  const _SectionTitleRow({required this.title, required this.onSeeAll});

  final String title;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              title,
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Semantics(
          button: true,
          label: 'See all $title',
          child: TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(
              backgroundColor: AppColors.surfaceVariant,
              foregroundColor: AppColors.textPrimary,
              minimumSize: const Size(0, 30),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('See All'),
          ),
        ),
      ],
    );
  }
}

class _RecentlyPlayedCard extends StatelessWidget {
  const _RecentlyPlayedCard({required this.track, required this.onTap});

  final Track track;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final artistName = track.artist.displayName?.trim().isNotEmpty == true
        ? track.artist.displayName!
        : track.artist.username;

    return Semantics(
      button: true,
      enabled: track.isPlayable,
      label: 'Play ${track.title} by $artistName',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 116,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TrackArtwork(track: track, size: 116),
              const SizedBox(height: AppDimensions.paddingXs),
              Text(
                track.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                artistName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrackArtwork extends StatelessWidget {
  const _TrackArtwork({required this.track, required this.size});

  final Track track;
  final double size;

  @override
  Widget build(BuildContext context) {
    final coverUrl = track.coverUrl?.trim();
    final fallback = Container(
      width: size,
      height: size,
      color: AppColors.surfaceVariant,
      child: const Icon(Icons.music_note, color: AppColors.textSecondary),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: coverUrl != null && coverUrl.isNotEmpty
          ? DecibelCachedImage(
              imageUrl: coverUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorWidget: fallback,
            )
          : fallback,
    );
  }
}

class _HistoryPreviewError extends StatelessWidget {
  const _HistoryPreviewError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Recently played failed to load',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: AppColors.borderDark, width: 0.6),
        ),
        child: Text(
          'Failed to load recently played.\n$message',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
