import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../library/domain/entities/track.dart';
import '../../../playlists/domain/entities/playlist.dart';
import '../../domain/entities/message_resource_preview.dart';
import 'message_bubble_resource_artwork.dart';

/// Tap target for a shared track or playlist embedded in a message.
///
/// Tracks route to the track preview screen, while playlists are converted into
/// a lightweight [Playlist] entity for the playlist tracks route.
class MessageBubbleResourcePreviewCard extends StatefulWidget {
  const MessageBubbleResourcePreviewCard({super.key, required this.resource});

  final MessageResourcePreview resource;

  @override
  State<MessageBubbleResourcePreviewCard> createState() =>
      _MessageBubbleResourcePreviewCardState();
}

class _MessageBubbleResourcePreviewCardState
    extends State<MessageBubbleResourcePreviewCard> {
  bool _isOpening = false;

  @override
  Widget build(BuildContext context) {
    final resource = widget.resource;
    final isTrack = resource.isTrack;

    return Semantics(
      button: true,
      label: isTrack
          ? 'Open track ${resource.displayTitle}'
          : 'Open playlist ${resource.displayTitle}',
      child: InkWell(
        onTap: () {
          if (_isOpening) return;

          final resourceId = resource.resourceId;
          if (resourceId == null) return;

          setState(() => _isOpening = true);

          if (isTrack) {
            context.push(RoutePaths.trackPreview(resourceId)).whenComplete(() {
              if (mounted) setState(() => _isOpening = false);
            });
            return;
          }

          context
              .push(
                RoutePaths.playlistTracks,
                extra: _toPlaylistEntity(resource),
              )
              .whenComplete(() {
                if (mounted) setState(() => _isOpening = false);
              });
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 310),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MessageBubbleResourceArtwork(
                imageUrl: resource.imageUrl,
                isTrack: isTrack,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource.displayTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      resource.displaySubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          isTrack ? Icons.music_note : Icons.queue_music,
                          size: 14,
                          color: Colors.white54,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isTrack ? 'Track' : 'Playlist',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the minimal playlist model needed by the playlist detail route.
  Playlist _toPlaylistEntity(MessageResourcePreview resource) {
    final subtitle = resource.displaySubtitle.trim();
    final ownerName = subtitle.isEmpty || subtitle == 'Playlist'
        ? 'Unknown User'
        : subtitle;

    return Playlist(
      id: resource.resourceId!,
      title: resource.displayTitle,
      description: null,
      type: 'PLAYLIST',
      isPrivate: false,
      isLiked: false,
      coverArt: resource.imageUrl,
      owner: PlaylistOwner(
        id: 0,
        username: ownerName,
        displayName: ownerName,
        avatarUrl: null,
      ),
      tracks: const <Track>[],
      totalDurationSeconds: 0,
      trackCount: 0,
      playlistSlug: null,
      secretToken: null,
      access: null,
      createdAt: null,
    );
  }
}
