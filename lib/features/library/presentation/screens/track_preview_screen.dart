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
    // Watch current track from player to allow switching details
    final audioState = ref.watch(trackAudioProvider);
    final currentTrackId = audioState.currentTrack?.id;

    // If something is playing, follow the player. Otherwise show the requested track.
    final effectiveTrackId = currentTrackId ?? trackId;

    ref.watch(trackPreviewAutoAudioInitProvider(effectiveTrackId));

    final previewAsync = ref.watch(trackPreviewProvider(effectiveTrackId));

    return Scaffold(
      backgroundColor: const Color(0xFF08131B),
      resizeToAvoidBottomInset: true,
      body: previewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _ErrorView(error: error.toString()),
        data: (data) => SafeArea(
          child: TrackPreviewContent(trackId: effectiveTrackId, data: data),
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
