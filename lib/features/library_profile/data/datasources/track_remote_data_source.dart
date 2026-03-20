import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/track_dto.dart';

abstract class ITrackRemoteDataSource {
  Future<List<TrackDto>> getUserTracks(int userId);
}

@LazySingleton(as: ITrackRemoteDataSource)
class TrackRemoteDataSourceImpl implements ITrackRemoteDataSource {
  const TrackRemoteDataSourceImpl(this.dio);

  final Dio dio;

  @override
  Future<List<TrackDto>> getUserTracks(int userId) async {
    try {
      final response = await dio.get('/users/$userId/tracks');
    final responseMap = response.data as Map<String, dynamic>;
    
    final nestedData = responseMap['data'] as Map<String, dynamic>?;

    final List<dynamic> content = (nestedData?['content'] as List<dynamic>?) ?? [];
    
    debugPrint('Successfully found ${content.length} tracks in the nested data.');
      return content
          .map((json) => TrackDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      // Map Dio errors to your architecture's ServerException
      throw ServerException(e.message ?? 'Unknown server error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}