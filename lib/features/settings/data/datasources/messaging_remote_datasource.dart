import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/message_model.dart';

abstract class IMessagingRemoteDataSource {
  Future<Map<String, dynamic>> getConversations(int page, int size);

  Future<String> startConversation(int targetUserId);

  Future<Map<String, dynamic>> getMessages(
    String conversationId,
    int page,
    int size,
  );

  Future<MessageModel> sendMessage(
    String conversationId,
    Map<String, dynamic> payload,
  );
}

@Injectable(as: IMessagingRemoteDataSource)
class MessagingRemoteDataSource implements IMessagingRemoteDataSource {
  const MessagingRemoteDataSource(this._api);

  final DioClient _api;

  @override
  Future<Map<String, dynamic>> getConversations(int page, int size) async {
    try {
      final response = await _api.get<Map<String, dynamic>>(
        ApiConstants.conversations,
        queryParams: {'page': page, 'size': size},
      );
      return response.data ?? {};
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch conversations');
    }
  }

  @override
  Future<String> startConversation(int targetUserId) async {
    try {
      final response = await _api.post<Map<String, dynamic>>(
        ApiConstants.startConversation(targetUserId),
        data: {},
      );

      final data = response.data ?? {};
      final conversationId = data['conversationId'] ?? data['id'];

      if (conversationId == null) {
        throw const ServerException('Missing conversation id in response');
      }

      return conversationId.toString();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const ServerException('User not found');
      }

      throw ServerException(e.message ?? 'Failed to start conversation');
    }
  }

  @override
  Future<Map<String, dynamic>> getMessages(
    String conversationId,
    int page,
    int size,
  ) async {
    try {
      final response = await _api.get<Map<String, dynamic>>(
        ApiConstants.conversationMessages(conversationId),
        queryParams: {'page': page, 'size': size},
      );
      return response.data ?? {};
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw const ServerException('Access denied to this conversation');
      }
      throw ServerException(e.message ?? 'Failed to fetch messages');
    }
  }

  @override
  Future<MessageModel> sendMessage(
    String conversationId,
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await _api.post<Map<String, dynamic>>(
        ApiConstants.conversationMessages(conversationId),
        data: payload,
      );

      final data = response.data;
      if (data == null) throw const ServerException('Empty response data');

      return MessageModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to send message');
    }
  }
}
