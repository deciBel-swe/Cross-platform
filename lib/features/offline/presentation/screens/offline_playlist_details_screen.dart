import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/decibel_cached_image.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../../library_profile/presentation/widgets/track_tile.dart';
import '../../data/datasources/offline_local_data_source.dart';
import '../../domain/repositories/i_offline_repository.dart';

/// Screen showing details of an offline playlist/station with all tracks.
class OfflinePlaylistDetailsScreen extends ConsumerStatefulWidget {
  const OfflinePlaylistDetailsScreen({
    super.key,
    required this.collection,
  });

  final OfflineCollectionInfo collection;

  @override
  ConsumerState<OfflinePlaylistDetailsScreen> createState() =>
      _OfflinePlaylistDetailsScreenState();
}

class _OfflinePlaylistDetailsScreenState
    extends ConsumerState<OfflinePlaylistDetailsScreen> {
  late final Future<List<Track>> _tracksFuture;

  @override
  void initState() {
    super.initState();
    _tracksFuture = _loadTracks();
  }

  Future<List<Track>> _loadTracks() async {
    final repo = getIt<IOfflineRepository>();
    final result = await repo.getDownloadedTracks();
    final allTracks = result.fold((_) => <Track>[], (t) => t);
    final trackById = {for (final t in allTracks) t.id: t};
    return widget.collection.trackIds
        .map((id) => trackById[id])
        .whereType<Track>()
        .toList();
  }

  Future<void> _renameCollection() async {
    final controller = TextEditingController(text: widget.collection.title);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Playlist'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter new name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && mounted) {
      final updatedInfo = widget.collection.copyWith(title: result);
      final repo = getIt<IOfflineRepository>();
      final updateResult = await repo.updateCollectionMetadata(updatedInfo);
      if (mounted) {
        updateResult.fold(
          (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(failure.message),
                backgroundColor: AppColors.errors,
              ),
            );
          },
          (_) {
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Playlist renamed')),
            );
          },
        );
      }
    }
  }

  Future<void> _deleteCollection() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Playlist'),
        content: Text(
          'Are you sure you want to delete "${widget.collection.title}"? '
          'This will only remove the playlist, not the downloaded tracks.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.errors,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final repo = getIt<IOfflineRepository>();
      final result = await repo.deleteCollectionMetadata(widget.collection.id);
      if (mounted) {
        result.fold(
          (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(failure.message),
                backgroundColor: AppColors.errors,
              ),
            );
          },
          (_) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Playlist deleted')),
            );
          },
        );
      }
    }
  }

  Future<void> _removeTrack(Track track) async {
    final repo = getIt<IOfflineRepository>();
    final result = await repo.removeTrackFromCollection(
      widget.collection.id,
      track.id,
    );
    if (mounted) {
      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
              backgroundColor: AppColors.errors,
            ),
          );
        },
        (_) {
          setState(() {
            _tracksFuture = _loadTracks();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Track removed from playlist')),
          );
        },
      );
    }
  }

  void _playTrack(Track track, List<Track> queue) {
    ref
        .read(trackAudioProvider.notifier)
        .playTrack(track: track, queue: queue, autoPlay: true);
  }

  @override
  Widget build(BuildContext context) {
    final coverUrl = widget.collection.coverUrl;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Rename',
            onPressed: _renameCollection,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete',
            onPressed: _deleteCollection,
          ),
        ],
      ),
      body: FutureBuilder<List<Track>>(
        future: _tracksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading tracks: ${snapshot.error}',
                style: const TextStyle(color: AppColors.errors),
              ),
            );
          }

          final tracks = snapshot.data ?? [];

          if (tracks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.collection.isStation
                        ? Icons.radio_rounded
                        : Icons.queue_music_rounded,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppDimensions.paddingMd),
                  Text(
                    'No tracks in this ${widget.collection.isStation ? 'station' : 'playlist'}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingLg),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusMd,
                            ),
                            child: coverUrl != null && coverUrl.isNotEmpty
                                ? DecibelCachedImage(
                                    imageUrl: coverUrl,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 120,
                                    height: 120,
                                    color: AppColors.surfaceVariant,
                                    child: Icon(
                                      widget.collection.isStation
                                          ? Icons.radio_rounded
                                          : Icons.queue_music_rounded,
                                      color: AppColors.textMuted,
                                      size: 48,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: AppDimensions.paddingLg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.collection.title,
                                  style: AppTextStyles.headlineMedium,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: AppDimensions.paddingSm),
                                Text(
                                  '${tracks.length} track${tracks.length == 1 ? '' : 's'}',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: AppDimensions.paddingSm),
                                Text(
                                  widget.collection.isStation
                                      ? 'Station'
                                      : 'Playlist',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.paddingLg),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Play All'),
                          onPressed: () => _playTrack(tracks.first, tracks),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMd,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final track = tracks[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Dismissible(
                          key: ValueKey(track.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16),
                            color: AppColors.errors.withValues(alpha: 0.2),
                            child: const Icon(
                              Icons.delete_outline,
                              color: AppColors.errors,
                            ),
                          ),
                          onDismissed: (_) => _removeTrack(track),
                          child: TrackTile(
                            track: track,
                            onTap: () => _playTrack(track, tracks),
                          ),
                        ),
                      );
                    },
                    childCount: tracks.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: MediaQuery.of(context).padding.bottom),
              ),
            ],
          );
        },
      ),
    );
  }
}
