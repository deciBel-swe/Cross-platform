import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/decibel_cached_image.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../providers/history_provider.dart';

/// Full-page view of the user's paginated listening history.
class RecentlyPlayedScreen extends ConsumerWidget {
  const RecentlyPlayedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
        title: Semantics(header: true, child: const Text('Recently Played')),
      ),
      body: historyAsync.when(
        loading: () => Semantics(
          label: 'Loading recently played tracks',
          child: const Center(child: CircularProgressIndicator()),
        ),
        error: (error, _) => _HistoryMessage(
          icon: Icons.error_outline,
          message: 'Failed to load recently played.\n$error',
        ),
        data: (history) {
          if (history.tracks.isEmpty) {
            return const _HistoryMessage(
              icon: Icons.history_rounded,
              message: 'No recently played tracks yet.',
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(historyProvider.notifier).refresh(),
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                final metrics = notification.metrics;
                if (metrics.pixels >= metrics.maxScrollExtent - 280) {
                  ref.read(historyProvider.notifier).loadMore();
                }
                return false;
              },
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.paddingMd,
                  AppDimensions.paddingSm,
                  AppDimensions.paddingMd,
                  AppDimensions.mobileMiniPlayerReservedSpace,
                ),
                itemCount:
                    history.tracks.length + (history.isLoadingMore ? 1 : 0),
                separatorBuilder: (_, _) =>
                    const Divider(color: AppColors.divider, height: 1),
                itemBuilder: (context, index) {
                  if (index >= history.tracks.length) {
                    return const Padding(
                      padding: EdgeInsets.all(AppDimensions.paddingMd),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final track = history.tracks[index];
                  return _HistoryTrackTile(
                    track: track,
                    onPlay: () =>
                        _playTrack(context, ref, track, history.tracks),
                  );
                },
              ),
            ),
          );
        },
      ),
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

class _HistoryTrackTile extends StatelessWidget {
  const _HistoryTrackTile({required this.track, required this.onPlay});

  final Track track;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final artistName = track.artist.displayName?.trim().isNotEmpty == true
        ? track.artist.displayName!
        : track.artist.username;

    return Semantics(
      button: true,
      enabled: track.isPlayable,
      label: 'Play ${track.title} by $artistName',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          excludeFromSemantics: true,
          onTap: onPlay,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.paddingSm,
            ),
            child: Row(
              children: [
                _HistoryArtwork(track: track, size: 56),
                const SizedBox(width: AppDimensions.paddingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.cardTitle,
                      ),
                      const SizedBox(height: AppDimensions.paddingXs),
                      Text(
                        artistName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.cardSubtitle,
                      ),
                    ],
                  ),
                ),
                Icon(
                  track.isPlayable
                      ? Icons.play_arrow_rounded
                      : Icons.lock_outline_rounded,
                  color: track.isPlayable
                      ? AppColors.textPrimary
                      : AppColors.textHint,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryArtwork extends StatelessWidget {
  const _HistoryArtwork({required this.track, required this.size});

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

class _HistoryMessage extends StatelessWidget {
  const _HistoryMessage({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: message,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.textSecondary, size: 40),
              const SizedBox(height: AppDimensions.paddingMd),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
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
