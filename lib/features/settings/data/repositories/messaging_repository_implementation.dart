import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/paginated_data.dart';
import '../../domain/entities/resource_type.dart';
import '../../domain/repositories/i_messaging_repository.dart';
import '../datasources/messaging_remote_datasource.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

@LazySingleton(as: IMessagingRepository)
class MessagingRepositoryImpl implements IMessagingRepository {
  const MessagingRepositoryImpl(this._remoteDataSource);

  final IMessagingRemoteDataSource _remoteDataSource;

  @override
  Future<PaginatedData<Conversation>> getConversations({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final data = await _remoteDataSource.getConversations(page, size);

      final contentList = (data['content'] as List<dynamic>?) ?? [];
      final conversations = contentList
          .map(
            (json) => ConversationModel.fromJson(
              json as Map<String, dynamic>,
            ).toEntity(),
          )
          .toList();

      return PaginatedData<Conversation>(
        content: conversations,
        pageNumber: data['pageNumber'] as int? ?? data['page'] as int? ?? 0,
        pageSize: data['pageSize'] as int? ?? data['size'] as int? ?? 20,
        totalElements: data['totalElements'] as int? ?? 0,
        totalPages: data['totalPages'] as int? ?? 1,
        isLast: data['isLast'] as bool? ?? data['last'] as bool? ?? true,
      );
    } on AppException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<String> startConversation(int targetUserId) async {
    try {
      return await _remoteDataSource.startConversation(targetUserId);
    } on AppException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<PaginatedData<Message>> getMessages({
    required String conversationId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final data = await _remoteDataSource.getMessages(
        conversationId,
        page,
        size,
      );

      final contentList = (data['content'] as List<dynamic>?) ?? [];
      final messages = contentList
          .map(
            (json) =>
                MessageModel.fromJson(json as Map<String, dynamic>).toEntity(),
          )
          .toList();

      return PaginatedData<Message>(
        content: messages,
        pageNumber: data['pageNumber'] as int? ?? data['page'] as int? ?? 0,
        pageSize: data['pageSize'] as int? ?? data['size'] as int? ?? 20,
        totalElements: data['totalElements'] as int? ?? 0,
        totalPages: data['totalPages'] as int? ?? 1,
        isLast: data['isLast'] as bool? ?? data['last'] as bool? ?? true,
      );
    } on AppException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<Message> sendMessage({
    required String conversationId,
    required String content,
    ResourceType? resourceType,
    int? resourceId,
    int? recipientId,
  }) async {
    try {
      if (recipientId == null) {
        throw const ServerFailure('Missing recipient ID');
      }

      final payload = <String, dynamic>{
        'content': content,
        'recipientId': recipientId,
      };

      final messageModel = await _remoteDataSource.sendMessage(
        conversationId,
        payload,
      );

      return messageModel.toEntity();
    } on AppException catch (e) {
      throw ServerFailure(e.message);
    } on ServerFailure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
