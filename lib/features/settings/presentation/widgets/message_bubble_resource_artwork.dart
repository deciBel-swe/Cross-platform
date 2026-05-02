import 'package:flutter/material.dart';

/// Artwork thumbnail for a shared track or playlist inside a message bubble.
///
/// Falls back to the matching resource icon when no usable image URL exists.
class MessageBubbleResourceArtwork extends StatelessWidget {
  const MessageBubbleResourceArtwork({
    super.key,
    required this.imageUrl,
    required this.isTrack,
  });

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
                  errorBuilder: (_, _, _) => Icon(
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
