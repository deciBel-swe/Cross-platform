// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationModelImpl _$$ConversationModelImplFromJson(
  Map<String, dynamic> json,
) => _$ConversationModelImpl(
  id: json['id'] as String,
  participants: json['participants'] == null
      ? const <int>[]
      : _participantsFromJson(json['participants']),
  lastMessage: json['lastMessage'] as String? ?? '',
  lastTimestamp: _parseDateTime(json['lastTimestamp']),
  unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$ConversationModelImplToJson(
  _$ConversationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'participants': instance.participants,
  'lastMessage': instance.lastMessage,
  'lastTimestamp': instance.lastTimestamp.toIso8601String(),
  'unreadCount': instance.unreadCount,
};
