import 'package:decibel/features/library/presentation/providers/track_preview_provider.dart';
import 'package:decibel/features/library/presentation/widgets/track_preview_bottom_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrackPreviewScreen extends ConsumerWidget {
  const TrackPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preview = ref.watch(trackPreviewProvider);

    return Scaffold(
      body: preview.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (data) =>
            Center(child: TrackPreviewBottomActions(track: data.track)),
      ),
    );
  }
}
