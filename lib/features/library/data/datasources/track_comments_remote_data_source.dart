import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/comment_reply_model.dart';
import '../models/paginated_comments_response_model.dart';
import '../models/paginated_replies_response_model.dart';
import '../models/post_comment_request_model.dart';
import '../models/post_comment_response_model.dart';

abstract class ITrackCommentsRemoteDataSource {
  Future<PostCommentResponseModel> postComment({
    required int trackId,
    required PostCommentRequestModel request,
  });

  Future<CommentReplyModel> postReply({
    required int commentId,
    required String body,
  });

  Future<PaginatedCommentsResponseModel> getComments({
    required int trackId,
    int page = 0,
    int size = 20,
  });

  Future<PaginatedRepliesResponseModel> getReplies({
    required int commentId,
    int page = 0,
    int size = 20,
  });

  Future<void> deleteComment({required int commentId});
}

@LazySingleton(as: ITrackCommentsRemoteDataSource)
class TrackCommentsRemoteDataSource implements ITrackCommentsRemoteDataSource {
  TrackCommentsRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<PostCommentResponseModel> postComment({
    required int trackId,
    required PostCommentRequestModel request,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '${ApiConstants.tracks}/$trackId${ApiConstants.comments}',
        data: request.toJson(),
      );

      final data = response.data;
      if (data == null) {
        throw Exception('Empty response');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PostCommentResponseModel.fromJson(data);
      }

      throw Exception(
        'Failed to post comment. Status code: ${response.statusCode}',
      );
    } on DioException catch (error) {
      throw Exception('Error occurred while posting comment: ${error.message}');
    }
  }

  @override
  Future<CommentReplyModel> postReply({
    required int commentId,
    required String body,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '${ApiConstants.comments}/$commentId${ApiConstants.replies}',
        data: {'body': body},
      );

      final data = response.data;
      if (data == null) {
        throw Exception('Empty response');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CommentReplyModel.fromJson(data);
      }

      throw Exception(
        'Failed to post reply. Status code: ${response.statusCode}',
      );
    } on DioException catch (error) {
      throw Exception('Error occurred while posting reply: ${error.message}');
    }
  }

  @override
  Future<PaginatedCommentsResponseModel> getComments({
    required int trackId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '${ApiConstants.tracks}/$trackId${ApiConstants.comments}',
        queryParams: {'page': page, 'size': size},
      );

      final data = response.data;
      if (data == null) {
        throw Exception('Empty response');
      }

      if (response.statusCode == 200) {
        return PaginatedCommentsResponseModel.fromJson(data);
      }

      throw Exception(
        'Failed to get comments. Status code: ${response.statusCode}',
      );
    } on DioException catch (error) {
      throw Exception(
        'Error occurred while getting comments: ${error.message}',
      );
    }
  }

  @override
  Future<PaginatedRepliesResponseModel> getReplies({
    required int commentId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '${ApiConstants.comments}/$commentId${ApiConstants.replies}',
        queryParams: {'page': page, 'size': size},
      );

      final data = response.data;
      if (data == null) {
        throw Exception('Empty response');
      }

      if (response.statusCode == 200) {
        return PaginatedRepliesResponseModel.fromJson(data);
      }

      throw Exception(
        'Failed to get replies. Status code: ${response.statusCode}',
      );
    } on DioException catch (error) {
      throw Exception('Error occurred while getting replies: ${error.message}');
    }
  }

  @override
  Future<void> deleteComment({required int commentId}) async {
    try {
      final response = await _dioClient.delete<dynamic>(
        '${ApiConstants.comments}/$commentId',
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        return;
      }

      throw Exception(
        'Failed to delete comment. Status code: ${response.statusCode}',
      );
    } on DioException catch (error) {
      throw Exception(
        'Error occurred while deleting comment: ${error.message}',
      );
    }
  }
}
