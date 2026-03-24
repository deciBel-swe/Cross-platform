import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library/domain/entities/track.dart';
import '../../../library/domain/entities/track_status.dart';
import 'upload_track_card/upload_track_card_container.dart';
import 'upload_track_card/upload_track_card_header.dart';
import 'upload_track_card/upload_track_card_play_button.dart';
import 'upload_track_card/upload_track_card_status_section.dart';

class UploadTrackCard extends ConsumerWidget {
  const UploadTrackCard({super.key, required this.track});
  //remove uncessary trackId parameter, as track object already contains the id and other necessary info
  final Track track;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProcessing = track.state == TrackStatus.processing;
    final canPlay = !isProcessing && (track.trackUrl?.isNotEmpty ?? false);

    return UploadTrackCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UploadTrackCardHeader(
            title: track.title,
            coverUrl: track.coverUrl,
            isProcessing: isProcessing,
            trailing: canPlay ? UploadTrackCardPlayButton(track: track) : null,
          ),
          const SizedBox(height: 10),
          UploadTrackCardStatusSection(state: track.state),
        ],
      ),
    );
  }
}
