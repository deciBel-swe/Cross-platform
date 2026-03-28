import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';

@injectable
class TrackSocialRemoteDatasource {
  const TrackSocialRemoteDatasource(this._dioClient);
  final DioClient _dioClient;

  Future<void> likeTrack(String trackId) async {
    try {
      await _dioClient.post<dynamic>('/api/tracks/$trackId/like');
    } catch (e) {
      throw const ServerException('Failed to like track');
    }
  }

  Future<void> unlikeTrack(String trackId) async {
    try {
      await _dioClient.delete<dynamic>('/api/tracks/$trackId/like');
    } catch (e) {
      throw const ServerException('Failed to unlike track');
    }
  }

  Future<void> repostTrack(String trackId) async {
    try {
      await _dioClient.post<dynamic>('/api/tracks/$trackId/repost');
    } catch (e) {
      throw const ServerException('Failed to repost track');
    }
  }

  Future<void> unrepostTrack(String trackId) async {
    try {
      await _dioClient.delete<dynamic>('/api/tracks/$trackId/repost');
    } catch (e) {
      throw const ServerException('Failed to remove repost');
    }
  }
}
