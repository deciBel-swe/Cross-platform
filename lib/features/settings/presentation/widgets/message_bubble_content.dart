import 'package:flutter/material.dart';

import '../../domain/entities/message_resource_preview.dart';
import 'message_bubble_resource_preview_card.dart';

class MessageBubbleContent extends StatelessWidget {
  const MessageBubbleContent({super.key, required this.parsed});

  final MessageResourcePreview parsed;

  @override
  Widget build(BuildContext context) {
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
          MessageBubbleResourcePreviewCard(resource: parsed),
        ],
      );
    }

    return Text(
      parsed.cleanText,
      style: const TextStyle(color: Colors.white, fontSize: 15),
    );
  }
}
