import 'package:flutter/material.dart';

import '../../../domain/entities/track_status.dart';
import 'upload_track_card_status_badge.dart';

class UploadTrackCardStatusSection extends StatelessWidget {
  const UploadTrackCardStatusSection({
    super.key,
    required this.trackId,
    required this.state,
  });

  final int trackId;
  final TrackStatus state;

  @override
  Widget build(BuildContext context) {
    final isProcessing = state == TrackStatus.processing;

    if (isProcessing) {
      return Align(
        alignment: Alignment.centerLeft,
        child: UploadTrackCardStatusBadge(state: state, showSpinner: true),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UploadTrackCardStatusBadge(state: state),
        const SizedBox(height: 10),
      ],
    );
  }
}
