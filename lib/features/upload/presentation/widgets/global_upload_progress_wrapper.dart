import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/global_upload_progress_provider.dart';

class GlobalUploadProgressWrapper extends ConsumerWidget {
  const GlobalUploadProgressWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(globalUploadProgressProvider);

    if (!state.isUploading && !state.isProcessing) {
      return child;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Tooltip(
                message: state.isProcessing ? 'Processing...' : 'Uploading...',
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: CircularProgressIndicator(
                    value: (state.progressPercent / 100.0).clamp(0.01, 1.0),
                    strokeWidth: 2.5,
                    color: state.isProcessing
                        ? AppColors.accentTeal
                        : Colors.orange, // Forced orange explicitly
                    backgroundColor: Colors.white24,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
