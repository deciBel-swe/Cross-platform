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
import '../../../offline/data/datasources/offline_local_data_source.dart';
import '../../../offline/domain/repositories/i_offline_repository.dart';
import '../../../offline/presentation/providers/offline_tracks_provider.dart';
import '../../../offline/presentation/screens/offline_playlist_details_screen.dart';

// ── Providers ─────────────────────────────────────────────────────────────────

final _offlineCollectionsProvider =
    FutureProvider.autoDispose<List<OfflineCollectionInfo>>((ref) async {
      final repo = getIt<IOfflineRepository>();
      final result = await repo.getOfflineCollections();
      return result.fold((_) => [], (c) => c);
    });

// ── Screen ────────────────────────────────────────────────────────────────────

class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsync = ref.watch(offlineTracksProvider);
    final collectionsAsync = ref.watch(_offlineCollectionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Semantics(header: true, child: const Text('Downloads')),
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.background,
      ),
      body: tracksAsync.when(
        data: (allTracks) {
          if (allTracks.isEmpty) {
            return Center(
              child: Semantics(
                label: 'No locally downloaded tracks',
                child: const Text(
                  'No locally downloaded tracks.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            );
          }

          return collectionsAsync.when(
            data: (collections) =>
                _DownloadsList(allTracks: allTracks, collections: collections),
            loading: () =>
                _DownloadsList(allTracks: allTracks, collections: const []),
            error: (_, __) =>
                _DownloadsList(allTracks: allTracks, collections: const []),
          );
        },
        loading: () => Semantics(
          label: 'Loading downloads',
          child: const Center(child: CircularProgressIndicator()),
        ),
        error: (error, _) => Center(
          child: Semantics(
            label: 'Error loading downloads',
            child: Text(
              'Error loading downloads: $error',
              style: const TextStyle(color: AppColors.errors),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Main list ─────────────────────────────────────────────────────────────────

class _DownloadsList extends ConsumerWidget {
  const _DownloadsList({required this.allTracks, required this.collections});

  final List<Track> allTracks;
  final List<OfflineCollectionInfo> collections;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Track IDs that belong to at least one collection.
    final collectionTrackIds = collections.expand((c) => c.trackIds).toSet();

    // Orphan tracks: downloaded individually (not part of any saved collection).
    final orphanTracks = allTracks
        .where((t) => !collectionTrackIds.contains(t.id))
        .toList();

    // Build a map for fast track lookup.
    final trackById = {for (final t in allTracks) t.id: t};

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingSm,
      ),
      children: [
        // ── Collections ──────────────────────────────────────────────────────
        if (collections.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingSm),
            child: Text(
              'Playlists & Stations',
              style: AppTextStyles.sectionTitle,
            ),
          ),
          for (final collection in collections)
            _CollectionCard(
              collection: collection,
              tracks: collection.trackIds
                  .map((id) => trackById[id])
                  .whereType<Track>()
                  .toList(),
            ),
          const SizedBox(height: AppDimensions.paddingMd),
        ],

        // ── Individual tracks ────────────────────────────────────────────────
        if (orphanTracks.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingSm),
            child: Text('Individual Tracks', style: AppTextStyles.sectionTitle),
          ),
          for (final track in orphanTracks)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TrackTile(
                track: track,
                onTap: () {
                  ref
                      .read(trackAudioProvider.notifier)
                      .playTrack(track: track, autoPlay: true);
                },
              ),
            ),
        ],
      ],
    );
  }
}

// ── Collection card ───────────────────────────────────────────────────────────

class _CollectionCard extends ConsumerWidget {
  const _CollectionCard({required this.collection, required this.tracks});

  final OfflineCollectionInfo collection;
  final List<Track> tracks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coverUrl = collection.coverUrl ?? tracks.firstOrNull?.coverUrl;

    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingSm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        onTap: () => _openDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          child: Row(
            children: [
              // Cover art
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                child: coverUrl != null && coverUrl.isNotEmpty
                    ? DecibelCachedImage(
                        imageUrl: coverUrl,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 64,
                        height: 64,
                        color: AppColors.surfaceVariant,
                        child: Icon(
                          collection.isStation
                              ? Icons.radio_rounded
                              : Icons.queue_music_rounded,
                          color: AppColors.textMuted,
                          size: 32,
                        ),
                      ),
              ),
              const SizedBox(width: AppDimensions.paddingMd),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collection.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${tracks.length} track${tracks.length == 1 ? '' : 's'}'
                      ' · ${collection.isStation ? 'Station' : 'Playlist'}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Play button
              IconButton(
                icon: const Icon(Icons.play_circle_outline_rounded),
                color: AppColors.primary,
                iconSize: 36,
                tooltip: 'Play ${collection.title}',
                onPressed: () => _playAll(ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OfflinePlaylistDetailsScreen(collection: collection),
      ),
    );
  }

  void _playAll(WidgetRef ref) {
    if (tracks.isEmpty) return;
    ref
        .read(trackAudioProvider.notifier)
        .playTrack(track: tracks.first, queue: tracks, autoPlay: true);
  }
}
