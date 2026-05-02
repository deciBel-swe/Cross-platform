import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/conversation.dart';

part 'conversation_model.freezed.dart';
part 'conversation_model.g.dart';

@freezed
class ConversationModel with _$ConversationModel {
  const factory ConversationModel({
    required String id,
    @JsonKey(fromJson: _participantsFromJson)
    @Default(<int>[])
    List<int> participants,
    @Default('') String lastMessage,
    @JsonKey(fromJson: _parseDateTime) required DateTime lastTimestamp,
    @Default(0) int unreadCount,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(_normalizeConversationJson(json));
}

Map<String, dynamic> _normalizeConversationJson(Map<String, dynamic> json) {
  final normalized = Map<String, dynamic>.from(json);

  normalized['participants'] = _participantsFromConversationId(
    normalized['id']?.toString(),
  );

  normalized['lastMessage'] =
      normalized['lastMessage'] ?? normalized['content'] ?? '';

  normalized['lastTimestamp'] =
      normalized['lastTimestamp'] ??
      normalized['createdAt'] ??
      normalized['updatedAt'] ??
      DateTime.now().toIso8601String();

  normalized['unreadCount'] = normalized['unreadCount'] ?? 0;

  return normalized;
}

List<int> _participantsFromJson(Object? value) {
  if (value is List) {
    return value
        .map((item) {
          if (item is int) return item;
          if (item is num) return item.toInt();
          if (item is String) return int.tryParse(item);
          return null;
        })
        .whereType<int>()
        .toList();
  }

  if (value is String) {
    return _participantsFromConversationId(value);
  }

  return const <int>[];
}

List<int> _participantsFromConversationId(String? id) {
  if (id == null || id.trim().isEmpty) return const <int>[];

  return id
      .split('_')
      .map((part) => int.tryParse(part.trim()))
      .whereType<int>()
      .toList();
}

DateTime _parseDateTime(Object? value) {
  if (value is DateTime) return value;

  final text = value?.toString();
  if (text == null || text.trim().isEmpty) {
    return DateTime.now();
  }

  final parsed = DateTime.tryParse(text);
  if (parsed == null) return DateTime.now();

  return parsed.isUtc ? parsed.toLocal() : parsed;
}

extension ConversationModelX on ConversationModel {
  Conversation toEntity() => Conversation(
    id: id,
    participants: participants,
    lastMessage: lastMessage,
    lastTimestamp: lastTimestamp,
    unreadCount: unreadCount,
  );
}
