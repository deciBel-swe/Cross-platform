import 'dart:convert';

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

  bool get hasResource => resourceType != null && resourceId != null;

  bool get isTrack => resourceType == 'TRACK';

  String get typeLabel => isTrack ? 'Track' : 'Playlist';

  String get displayTitle {
    final value = title?.trim();
    if (value != null && value.isNotEmpty) return value;
    return typeLabel;
  }

  String get displaySubtitle {
    final value = subtitle?.trim();
    if (value != null && value.isNotEmpty) return value;
    return typeLabel;
  }

  String get inboxPreviewText {
    if (!hasResource) return cleanText;

    return typeLabel;
  }
}

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
