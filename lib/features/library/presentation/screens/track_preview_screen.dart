import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_error_widget.dart';
import '../../../library_profile/presentation/providers/track_preview_derived_providers.dart';
import '../../../library_profile/presentation/providers/track_preview_provider.dart';
import '../widgets/track_preview_content.dart';

class TrackPreviewScreen extends ConsumerWidget {
  const TrackPreviewScreen({super.key, required this.trackId});

  final int trackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(trackPreviewAutoAudioInitProvider(trackId));

    final previewAsync = ref.watch(trackPreviewProvider(trackId));

    return Scaffold(
      backgroundColor: const Color(0xFF08131B),
      resizeToAvoidBottomInset: true,
      body: previewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => AppErrorWidget(
          error: error,
          onRetry: () {
            ref.invalidate(trackPreviewProvider(trackId));
          },
        ),
        data: (data) => SafeArea(
          child: TrackPreviewContent(trackId: trackId, data: data),
        ),
      ),
    );
  }
}

