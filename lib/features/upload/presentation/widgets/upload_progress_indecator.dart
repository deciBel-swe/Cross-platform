import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/upload_progress_provider.dart';

class UploadProgressIndicator extends ConsumerWidget {
  const UploadProgressIndicator({
    super.key,
    required this.correlationId,
  });

  final String correlationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(uploadProgressProvider(correlationId));

    return progressAsync.when(
      data: (progress) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: AppColors.surface,
            color: AppColors.primary,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(
            'Processing... ${progress.toStringAsFixed(1)}%',
            style: const TextStyle(
              color: AppColors.onPrimary,
              fontSize: 12,
            ),
          ),
        ],
      ),
      loading: () => const LinearProgressIndicator(
        backgroundColor: AppColors.surface,
        color: AppColors.primary,
      ),
      error: (error, stack) => Text(
        'Progress error: $error',
        style: const TextStyle(color: AppColors.errors, fontSize: 12),
      ),
    );
  }
}