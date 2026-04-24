// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationModelImpl _$$ConversationModelImplFromJson(
  Map<String, dynamic> json,
) => _$ConversationModelImpl(
  id: json['id'] as String,
  participants: (json['participants'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  lastMessage: json['lastMessage'] as String? ?? '',
  lastTimestamp: _parseUtcDateTime(json['lastTimestamp'] as String),
);

Map<String, dynamic> _$$ConversationModelImplToJson(
  _$ConversationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'participants': instance.participants,
  'lastMessage': instance.lastMessage,
  'lastTimestamp': instance.lastTimestamp.toIso8601String(),
};
