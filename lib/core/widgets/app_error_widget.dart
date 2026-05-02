import 'package:flutter/material.dart';

import '../../../features/offline/presentation/widgets/offline_indicator.dart';
import '../errors/exceptions.dart';
import '../errors/failures.dart';

/// A global error widget that renders appropriate UI for different error types.
/// Displays an [OfflineIndicator] for network errors, and a generic error UI
/// for server or unknown errors.
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
  });

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determine if the error is related to network connectivity
    final localError = error;
    final isNetworkError = localError is NetworkException ||
        (localError is Failure && localError.message.toLowerCase().contains('internet connection')) ||
        localError.toString().toLowerCase().contains('no internet connection') ||
        localError.toString().toLowerCase().contains('network exception');

    if (isNetworkError) {
      return OfflineIndicator(onRetry: onRetry);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _extractMessage(error),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  String _extractMessage(Object error) {
    if (error is AppException) return error.message;
    if (error is Failure) return error.message;
    
    // Clean up generic exception prefixes if present
    final str = error.toString();
    if (str.startsWith('Exception: ')) {
      return str.substring(11);
    }
    return str;
  }
}
