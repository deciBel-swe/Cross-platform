import 'dart:convert';

/// Parsed representation of a resource marker embedded in message text.
///
/// [cleanText] is the human-written message with the marker removed. The
/// resource fields describe the shared track or playlist when one is present.
class MessageResourcePreview {
  const MessageResourcePreview({
    required this.cleanText,
    this.resourceType,
    this.resourceId,
    this.title,
    this.subtitle,
    this.imageUrl,
  });

  final String cleanText;
  final String? resourceType;
  final int? resourceId;
  final String? title;
  final String? subtitle;
  final String? imageUrl;

  /// Whether the message contains a usable resource reference.
  bool get hasResource => resourceType != null && resourceId != null;

  /// Whether the referenced resource is a track.
  bool get isTrack => resourceType == 'TRACK';

  /// Title shown in chat previews, with a resource-type fallback.
  String get displayTitle {
    final value = title?.trim();
    if (value != null && value.isNotEmpty) return value;
    return isTrack ? 'Track' : 'Playlist';
  }

  /// Subtitle shown in chat previews, with a resource-type fallback.
  String get displaySubtitle {
    final value = subtitle?.trim();
    if (value != null && value.isNotEmpty) return value;
    return isTrack ? 'Track' : 'Playlist';
  }

  /// Short resource label used in conversation summaries.
  String get conversationLabel {
    return isTrack ? 'Track' : 'Playlist';
  }
}

/// Encodes a shared resource payload and appends it to optional message text.
String buildResourceMessageContent({
  required String resourceType,
  required int resourceId,
  required String title,
  String? subtitle,
  String? imageUrl,
  String text = '',
}) {
  final payload = <String, dynamic>{
    'type': resourceType,
    'id': resourceId,
    'title': title,
    'subtitle': subtitle,
    'imageUrl': imageUrl,
  };

  final encoded = base64Url.encode(utf8.encode(jsonEncode(payload)));
  final marker = '[[DECIBEL_RESOURCE_FULL:$encoded]]';
  final cleanText = text.trim();

  if (cleanText.isEmpty) return marker;
  return '$cleanText $marker';
}

/// Extracts a resource marker from [content] and returns clean display text.
///
/// Supports both the current base64 JSON marker and the older compact marker
/// format so existing conversations keep rendering correctly.
MessageResourcePreview parseMessageResourceContent(String content) {
  final fullRegex = RegExp(r'\[\[DECIBEL_RESOURCE_FULL:([A-Za-z0-9_\-=]+)\]\]');

  final fullMatch = fullRegex.firstMatch(content);

  if (fullMatch != null) {
    try {
      final encoded = fullMatch.group(1)!;
      final decoded = utf8.decode(base64Url.decode(encoded));
      final json = jsonDecode(decoded) as Map<String, dynamic>;

      final type = json['type'] as String?;
      final id = (json['id'] as num?)?.toInt();

      return MessageResourcePreview(
        cleanText: content.replaceFirst(fullRegex, '').trim(),
        resourceType: type,
        resourceId: id,
        title: json['title'] as String?,
        subtitle: json['subtitle'] as String?,
        imageUrl: json['imageUrl'] as String?,
      );
    } catch (_) {
      return MessageResourcePreview(cleanText: content);
    }
  }

  final oldRegex = RegExp(r'\[\[DECIBEL_RESOURCE:(TRACK|PLAYLIST):(\d+)\]\]');
  final oldMatch = oldRegex.firstMatch(content);

  if (oldMatch == null) {
    return MessageResourcePreview(cleanText: content);
  }

  final type = oldMatch.group(1);
  final id = int.tryParse(oldMatch.group(2) ?? '');

  return MessageResourcePreview(
    cleanText: content.replaceFirst(oldRegex, '').trim(),
    resourceType: type,
    resourceId: id,
  );
}
