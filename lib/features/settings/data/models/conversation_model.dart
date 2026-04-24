import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/conversation.dart';

part 'conversation_model.freezed.dart';
part 'conversation_model.g.dart';

@freezed
class ConversationModel with _$ConversationModel {
  const factory ConversationModel({
    required String id,
    required List<int> participants,
    @Default('') String lastMessage,
    @JsonKey(fromJson: _parseUtcDateTime) required DateTime lastTimestamp,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);
}

DateTime _parseUtcDateTime(String value) {
  return DateTime.parse('${value}Z').toLocal();
}

extension ConversationModelX on ConversationModel {
  Conversation toEntity() => Conversation(
    id: id,
    participants: participants,
    lastMessage: lastMessage,
    lastTimestamp: lastTimestamp,
  );
}
