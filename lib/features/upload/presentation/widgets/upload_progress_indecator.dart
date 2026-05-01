import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/upload_sessions_provider.dart';

class UploadProgressIndicator extends ConsumerWidget {
  const UploadProgressIndicator({
    super.key,
    required this.trackId,
    this.isFailed = false,
  });

  final int trackId;
  final bool isFailed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final session = ref.watch(uploadSessionByTrackIdProvider(trackId));
    final progress = session?.progressPercentage ?? 0;
    final normalizedProgress = progress.clamp(0, 100) / 100.0;
    final stepName = session?.stepName;
    final errorMessage = session?.errorMessage;
    final showFailure = isFailed || session?.isFailed == true;
    final isDeterminate = session != null && progress > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        LinearProgressIndicator(
          value: showFailure
              ? 1.0
              : isDeterminate
              ? normalizedProgress
              : null,
          backgroundColor: AppColors.surface,
          color: showFailure ? AppColors.errors : AppColors.primary,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 8),
        Text(
          _buildLabel(
            progress: progress,
            stepName: stepName,
            errorMessage: errorMessage,
            showFailure: showFailure,
          ),
          style: theme.textTheme.bodySmall?.copyWith(
            color: showFailure ? AppColors.errors : AppColors.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _buildLabel({
    required int progress,
    required String? stepName,
    required String? errorMessage,
    required bool showFailure,
  }) {
    if (showFailure) {
      return errorMessage ?? 'Upload failed';
    }

    final normalizedStepName = stepName?.trim();
    if (normalizedStepName != null && normalizedStepName.isNotEmpty) {
      return '$normalizedStepName - $progress%';
    }

    if (progress > 0) {
      return 'Processing... $progress%';
    }

    return 'Processing...';
  }
}
