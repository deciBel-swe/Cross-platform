import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../providers/track_preview_provider.dart';
import '../providers/uploads_provider.dart';
import '../widgets/upload_track_card.dart';

class UploadsLibraryScreen extends ConsumerStatefulWidget {
  const UploadsLibraryScreen({super.key});

  @override
  ConsumerState<UploadsLibraryScreen> createState() =>
      _UploadsLibraryScreenState();
}

class _UploadsLibraryScreenState extends ConsumerState<UploadsLibraryScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;

    // Load next page when the user is close to the bottom.
    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(uploadsProvider.notifier).loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uploadsAsync = ref.watch(uploadsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Uploads')),
      body: uploadsAsync.when(
        data: (tracks) {
          if (tracks.isEmpty) {
            return Center(
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
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(uploadsProvider.notifier).refreshAll(),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                final track = tracks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      ref.read(selectedTrackIdProvider.notifier).state =
                          track.id;
                      context.push(RoutePaths.trackPreview);
                    },
                    child: UploadTrackCard(
                      key: ValueKey(track.id),
                      track: track,
                    ),
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
                onPressed: () =>
                    ref.read(uploadsProvider.notifier).refreshAll(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
