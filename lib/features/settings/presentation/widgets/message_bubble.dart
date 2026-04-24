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
    final parsed = _parseMessageResource(message.content);

    return Semantics(
      label:
          'Message from ${isMe ? 'You' : 'Them'}, sent $timeString. '
          '${parsed.hasResource ? 'Contains shared ${parsed.resourceType?.toLowerCase()}.' : ''} '
          'Message reads: ${parsed.cleanText.isEmpty ? 'Shared resource' : parsed.cleanText}',
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

  Widget _buildContent(BuildContext context, _ParsedMessageResource parsed) {
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
          _RegexResourceCard(
            resourceType: parsed.resourceType!,
            resourceId: parsed.resourceId!,
          ),
        ],
      );
    }

    return Text(
      parsed.cleanText,
      style: const TextStyle(color: Colors.white, fontSize: 15),
    );
  }

  _ParsedMessageResource _parseMessageResource(String content) {
    final regex = RegExp(r'\[\[DECIBEL_RESOURCE:(TRACK|PLAYLIST):(\d+)\]\]');
    final match = regex.firstMatch(content);

    if (match == null) {
      return _ParsedMessageResource(cleanText: content);
    }

    final resourceType = match.group(1);
    final resourceId = int.tryParse(match.group(2) ?? '');
    final cleanText = content.replaceFirst(regex, '').trim();

    return _ParsedMessageResource(
      cleanText: cleanText,
      resourceType: resourceType,
      resourceId: resourceId,
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

class _ParsedMessageResource {
  const _ParsedMessageResource({
    required this.cleanText,
    this.resourceType,
    this.resourceId,
  });

  final String cleanText;
  final String? resourceType;
  final int? resourceId;

  bool get hasResource => resourceType != null && resourceId != null;
}

/// Helper composite to project shared tracks or dynamic network playlists.
///
/// Features:
/// - Provides semantic safety boundaries wrapping layout components.
class _RegexResourceCard extends StatelessWidget {
  const _RegexResourceCard({
    required this.resourceType,
    required this.resourceId,
  });

  final String resourceType;
  final int resourceId;

  @override
  Widget build(BuildContext context) {
    final isTrack = resourceType == 'TRACK';

    return Semantics(
      button: true,
      label: isTrack
          ? 'Open shared track with id $resourceId'
          : 'Open shared playlist with id $resourceId',
      child: InkWell(
        onTap: () {
          if (isTrack) {
            context.push(RoutePaths.trackPreview(resourceId));
          } else {
            context.push(RoutePaths.playlists);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 260),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isTrack ? Icons.music_note : Icons.queue_music,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isTrack ? 'Shared track' : 'Shared playlist',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isTrack ? 'Tap to open track' : 'Tap to open playlists',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
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
