import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/dio_error_handler.dart';
import '../models/track_dto.dart';

abstract class ITrackRemoteDataSource {
  Future<List<TrackDto>> getUserTracks(int userId);
}

@LazySingleton(as: ITrackRemoteDataSource)
class TrackRemoteDataSourceImpl implements ITrackRemoteDataSource {
  const TrackRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<List<TrackDto>> getUserTracks(int userId) async {
    try {
      final response = await _dioClient.get<dynamic>('/users/$userId/tracks');
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        return [];
      }

      final nestedData = data['data'];
      final List<dynamic> contentList = (nestedData is Map<String, dynamic>)
          ? (nestedData['content'] as List<dynamic>? ?? [])
          : [];

      return contentList
          .whereType<Map<String, dynamic>>()
          .map((trackJson) => TrackDto.fromJson(trackJson))
          .toList();
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e, fallback: 'Failed to fetch tracks');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
