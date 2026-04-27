import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../discovery/domain/entities/paginated_discovery_tracks.dart';
import '../../../discovery/presentation/providers/discovery_provider.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../../library_profile/presentation/widgets/track_tile.dart';
import '../utils/discovery_track_mapper.dart';

enum HomeCollectionKind { popular }

class HomeCollectionScreen extends ConsumerWidget {
  const HomeCollectionScreen({super.key, required this.kind});

  final HomeCollectionKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsync = switch (kind) {
      HomeCollectionKind.popular => ref.watch(
          popularTracksProvider((page: 0, size: 40)),
        ),
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(_titleForKind(kind)),
      ),
      body: tracksAsync.when(
        data: (response) => _TrackCollection(response: response),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLg),
            child: Text(
              error.toString().replaceFirst('Exception: ', ''),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.errors,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TrackCollection extends ConsumerWidget {
  const _TrackCollection({required this.response});

  final PaginatedDiscoveryTracks response;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (response.content.isEmpty) {
      return Center(
        child: Text(
          'No tracks are available yet.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    final tracks = discoveryTracksToLibraryTracks(response.content);

    return ListView.builder(
      padding: const EdgeInsets.only(
        top: AppDimensions.paddingMd,
        bottom: 96,
      ),
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        final track = tracks[index];
        return TrackTile(
          key: ValueKey('home_collection_${track.id}'),
          track: track,
          onTap: () {
            ref.read(trackAudioProvider.notifier).playTrack(
                  track: track,
                  queue: tracks,
                  autoPlay: true,
                );
          },
        );
      },
    );
  }
}

String _titleForKind(HomeCollectionKind kind) {
  switch (kind) {
    case HomeCollectionKind.popular:
      return 'Popular Tracks';
  }
}
