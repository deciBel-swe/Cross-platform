import 'package:flutter/material.dart';

import '../../../../library/domain/entities/track_status.dart';

class UploadTrackCardStatusBadge extends StatelessWidget {
  const UploadTrackCardStatusBadge({
    super.key,
    required this.state,
    this.showSpinner = false,
  });

  final TrackStatus state;
  final bool showSpinner;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isProcessing = state == TrackStatus.processing;

    final label = isProcessing ? 'Processing' : 'Finished';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isProcessing
            ? theme.colorScheme.secondaryContainer
            : theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isProcessing && showSpinner) ...[
            SizedBox(
              height: 12,
              width: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isProcessing
                  ? theme.colorScheme.onSecondaryContainer
                  : theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
