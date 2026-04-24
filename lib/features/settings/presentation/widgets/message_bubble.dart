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
import '../../domain/entities/resource_type.dart';

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

    return Semantics(
      label:
          'Message from ${isMe ? 'You' : 'Them'}, sent $timeString. '
          '${message.resourceType != null ? 'Contains attached media type ${message.resourceType!.value}.' : ''} '
          'Message reads: ${message.content}',
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
                    child: _buildContent(context),
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

  Widget _buildContent(BuildContext context) {
    if (message.resourceType != null && message.resourceId != null) {
      return _MediaResourceCard(
        resourceType: message.resourceType!,
        resourceId: message.resourceId!,
      );
    }

    return Text(
      message.content,
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

/// Helper composite to project shared tracks or dynamic network playlists.
///
/// Features:
/// - Provides semantic safety boundaries wrapping layout components.
class _MediaResourceCard extends StatelessWidget {
  const _MediaResourceCard({
    required this.resourceType,
    required this.resourceId,
  });

  final ResourceType resourceType;
  final int resourceId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: 48,
            height: 48,
            color: Colors.black45,
            child: const Icon(Icons.music_note, color: Colors.white54),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shared ${resourceType.value}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Resource ID: $resourceId',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
