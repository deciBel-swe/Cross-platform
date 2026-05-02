import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_error_widget.dart';
import '../../../library_profile/presentation/providers/track_preview_derived_providers.dart';
import '../../../library_profile/presentation/providers/track_preview_provider.dart';
import '../widgets/track_preview_content.dart';

class TrackPreviewScreen extends ConsumerStatefulWidget {
  const TrackPreviewScreen({super.key, required this.trackId});

  final int trackId;

  @override
  ConsumerState<TrackPreviewScreen> createState() => _TrackPreviewScreenState();
}

class _TrackPreviewScreenState extends ConsumerState<TrackPreviewScreen> {
  bool _isMinimizing = false;

  Future<void> _minimize() async {
    if (_isMinimizing) return;

    setState(() => _isMinimizing = true);
    await Future<void>.delayed(const Duration(milliseconds: 220));

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(trackPreviewAutoAudioInitProvider(widget.trackId));

    final previewAsync = ref.watch(trackPreviewProvider(widget.trackId));

    return Scaffold(
      backgroundColor: const Color(0xFF08131B),
      resizeToAvoidBottomInset: true,
      body: previewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => AppErrorWidget(
          error: error,
          onRetry: () {
            ref.invalidate(trackPreviewProvider(widget.trackId));
          },
        ),
        data: (data) => SafeArea(
          child: AnimatedSlide(
            offset: _isMinimizing ? const Offset(0, 0.08) : Offset.zero,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInCubic,
            child: AnimatedOpacity(
              opacity: _isMinimizing ? 0 : 1,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              child: TrackPreviewContent(
                trackId: widget.trackId,
                data: data,
                onMinimize: _minimize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
