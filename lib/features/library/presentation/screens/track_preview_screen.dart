import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../../library_profile/presentation/providers/track_preview_derived_providers.dart';
import '../../../library_profile/presentation/providers/track_preview_provider.dart';
import '../widgets/track_preview_content.dart';

class TrackPreviewScreen extends ConsumerWidget {
  const TrackPreviewScreen({super.key, required this.trackId});

  final int trackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the currently playing track ID from the player
    final playingId = ref.watch(
      trackAudioProvider.select((s) => s.preparedTrackId),
    );

    // Use the playing track ID if available, otherwise use the ID from the route
    final effectiveId = playingId ?? trackId;

    // Initialize audio for the effective track
    ref.watch(trackPreviewAutoAudioInitProvider(effectiveId));

    // Fetch preview data for the effective track
    final previewAsync = ref.watch(trackPreviewProvider(effectiveId));

    return Scaffold(
      backgroundColor: const Color(0xFF08131B),
      resizeToAvoidBottomInset: true,
      body: previewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _ErrorView(error: error.toString()),
        data: (data) => SafeArea(
          child: TrackPreviewContent(trackId: effectiveId, data: data),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Failed to load preview.\n$error',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
