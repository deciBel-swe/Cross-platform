import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library_profile/presentation/providers/uploads_provider.dart';
import '../../../library_profile/presentation/providers/uploads_scroll_controller_provider.dart';
import '../../../library_profile/presentation/widgets/track_tile.dart';
import '../../../upload/presentation/providers/upload_sessions_provider.dart';
import '../../../upload/presentation/widgets/upload_progress_indecator.dart';

class UploadsLibraryScreen extends ConsumerWidget {
  const UploadsLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Your Uploads'),
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
      ),
      body: const UploadsLibraryBody(),
    );
  }
}

class UploadsLibraryBody extends ConsumerWidget {
  const UploadsLibraryBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final uploadsAsync = ref.watch(uploadsProvider);
    final scrollController = ref.watch(uploadsScrollControllerProvider);
    final uploadSessions = ref.watch(uploadSessionsProvider);

    return uploadsAsync.when(
      // UX fix: keeps list visible during refresh/loading.
      skipLoadingOnRefresh: true,
      data: (tracks) {
        final displayTracks = _mergeTracks(
          tracks: tracks,
          sessions: uploadSessions.values,
        );

        if (displayTracks.isEmpty) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return RefreshIndicator(
                onRefresh: () =>
                    ref.read(uploadsProvider.notifier).refreshAll(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 64,
                            color: theme.disabledColor,
                          ),
                          const SizedBox(height: 16),
                          const Text('No uploads yet.'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                ref.read(uploadsProvider.notifier).refreshAll(),
                            child: const Text('Refresh'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(uploadsProvider.notifier).refreshAll(),
          child: ListView.builder(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              16 + AppDimensions.mobileMiniPlayerReservedSpace,
            ),
            itemCount: displayTracks.length,
            itemBuilder: (context, index) {
              final track = displayTracks[index];
              final session = ref.watch(
                uploadSessionByTrackIdProvider(track.id),
              );
              final showUploadStatus =
                  session != null || track.isProcessing || track.isFailed;
              final isUnavailable = showUploadStatus || !track.isPlayable;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AbsorbPointer(
                      absorbing: isUnavailable,
                      child: Opacity(
                        opacity: showUploadStatus ? 0.55 : 1.0,
                        child: TrackTile(
                          key: ValueKey(track.id),
                          track: track,
                          onTap: track.isPlayable
                              ? () {
                                  context.push(
                                    RoutePaths.trackPreview(track.id),
                                  );
                                }
                              : null,
                        ),
                      ),
                    ),

                    if (showUploadStatus) ...[
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: UploadProgressIndicator(
                          trackId: track.id,
                          isFailed: session?.isFailed == true || track.isFailed,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $err'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(uploadsProvider.notifier).refreshAll(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

List<Track> _mergeTracks({
  required List<Track> tracks,
  required Iterable<UploadSession> sessions,
}) {
  final mergedTracks = <Track>[];
  final seenTrackIds = <int>{};

  for (final session in sessions) {
    if (seenTrackIds.add(session.trackId)) {
      mergedTracks.add(session.track);
    }
  }

  for (final track in tracks) {
    if (seenTrackIds.add(track.id)) {
      mergedTracks.add(track);
    }
  }

  return mergedTracks;
}
