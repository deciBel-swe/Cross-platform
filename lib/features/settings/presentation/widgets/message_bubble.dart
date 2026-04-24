/// Visually renders an individual chat message inside a conversation context.
/// Features:
/// - Automatically shifts alignment based on message sender context (Me vs Them).
/// - Conditionally evaluates and displays embedded rich media objects seamlessly.
/// - Enforces comprehensive explicit semantic boundaries across textual nodes.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/message_resource_preview.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.otherUserId,
  });

  final Message message;
  final bool isMe;
  final int? otherUserId;

  @override
  Widget build(BuildContext context) {
    final timeString = _formatTimeAgo(message.createdAt);
    final parsed = parseMessageResourceContent(message.content);

    return Semantics(
      label:
          'Message from ${isMe ? 'You' : 'Them'}, sent $timeString. '
          '${parsed.hasResource ? 'Contains shared ${parsed.resourceType?.toLowerCase()}.' : ''} '
          'Message reads: ${parsed.cleanText.isEmpty ? parsed.displayTitle : parsed.cleanText}',
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Row(
          mainAxisAlignment: isMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe) ...[
              GestureDetector(
                onTap: otherUserId == null
                    ? null
                    : () => context.push(
                        RoutePaths.publicProfile(otherUserId.toString()),
                      ),
                child: const ExcludeSemantics(
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.surface,
                    child: Icon(Icons.person, color: Colors.white54),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _buildContent(context, parsed),
                  ),
                  const SizedBox(height: 6),
                  ExcludeSemantics(
                    child: Text(
                      timeString,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MessageResourcePreview parsed) {
    if (parsed.hasResource) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (parsed.cleanText.isNotEmpty) ...[
            Text(
              parsed.cleanText,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(height: 10),
          ],
          _ResourcePreviewCard(resource: parsed),
        ],
      );
    }

    return Text(
      parsed.cleanText,
      style: const TextStyle(color: Colors.white, fontSize: 15),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final safeDate = date.isAfter(now) ? now : date;
    final difference = now.difference(safeDate);

    if (difference.inDays > 30) {
      final months = difference.inDays ~/ 30;
      return '$months month${months == 1 ? '' : 's'} ago';
    }
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    }
    if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    }
    if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min${difference.inMinutes == 1 ? '' : 's'} ago';
    }
    return 'Just now';
  }
}

class _ResourcePreviewCard extends StatelessWidget {
  const _ResourcePreviewCard({required this.resource});

  final MessageResourcePreview resource;

  @override
  Widget build(BuildContext context) {
    final isTrack = resource.isTrack;

    return Semantics(
      button: true,
      label: isTrack
          ? 'Open track ${resource.displayTitle}'
          : 'Open playlist ${resource.displayTitle}',
      child: InkWell(
        onTap: () {
          if (isTrack) {
            context.push(RoutePaths.trackPreview(resource.resourceId!));
          } else {
            context.push(RoutePaths.playlists);
          }
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
              _ResourceArtwork(imageUrl: resource.imageUrl, isTrack: isTrack),
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
}

class _ResourceArtwork extends StatelessWidget {
  const _ResourceArtwork({required this.imageUrl, required this.isTrack});

  final String? imageUrl;
  final bool isTrack;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();

    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 58,
          height: 58,
          color: Colors.black45,
          child: url == null || url.isEmpty
              ? Icon(
                  isTrack ? Icons.music_note : Icons.queue_music,
                  color: Colors.white70,
                  size: 28,
                )
              : Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    isTrack ? Icons.music_note : Icons.queue_music,
                    color: Colors.white70,
                    size: 28,
                  ),
                ),
        ),
      ),
    );
  }
}
