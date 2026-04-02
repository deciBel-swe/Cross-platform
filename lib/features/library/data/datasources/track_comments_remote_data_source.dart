import 'package:injectable/injectable.dart';

import '../../../../core/network/dio_client.dart';
import '../models/post_comment_request_model.dart';
import '../models/post_comment_response_model.dart';

abstract class ITrackCommentsRemoteDataSource {
  Future<PostCommentResponseModel> postComment({
    required int trackId,
    required PostCommentRequestModel request,
  });
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
        '/tracks/$trackId/comments',
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
    } catch (e) {
      throw Exception('Error occurred while posting comment: $e');
    }
  }
}
