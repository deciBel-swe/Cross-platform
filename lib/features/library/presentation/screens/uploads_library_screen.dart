import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../providers/uploads_provider.dart';
import '../providers/uploads_scroll_controller_provider.dart';
import '../widgets/upload_track_card.dart';

class UploadsLibraryScreen extends ConsumerWidget {
  const UploadsLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Uploads')),
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
            padding: const EdgeInsets.all(16),
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final track = tracks[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    context.push(RoutePaths.trackPreview(track.id));
                  },
                  child: UploadTrackCard(key: ValueKey(track.id), track: track),
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
