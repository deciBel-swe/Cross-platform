import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../library_profile/presentation/providers/uploads_provider.dart';
import '../../../library_profile/presentation/providers/uploads_scroll_controller_provider.dart';
import '../../../library_profile/presentation/widgets/track_tile.dart';
import '../../../upload/presentation/providers/upload_notifier.dart';
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

    return uploadsAsync.when(
      // UX fix: keeps list visible during refresh/loading.
      skipLoadingOnRefresh: true,
      data: (tracks) {
        if (tracks.isEmpty) {
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
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final track = tracks[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TrackTile(
                      key: ValueKey(track.id),
                      track: track,
                      // Disable tapping if it is still uploading
                      onTap: track.state.toString() == 'PROCESSING'
                          ? null
                          : () {
                              context.push(RoutePaths.trackPreview(track.id));
                            },
                    ),

                    // Show the progress bar ONLY if the track is processing
                    if (track.state.toString() == 'PROCESSING') ...[
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Consumer(
                          builder: (context, ref, child) {
                            // Read the memory map we made in the notifier
                            final uploadMap = ref.watch(
                              activeUploadsMapProvider,
                            );

                            // Get the UUID, fallback to ID string just to be safe
                            final websocketId =
                                uploadMap[track.id] ?? track.id.toString();

                            return UploadProgressIndicator(
                              correlationId: websocketId,
                            );
                          },
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
