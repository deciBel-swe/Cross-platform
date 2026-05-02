import 'package:injectable/injectable.dart';

import '../../../../core/network/dio_client.dart';

abstract class IModerationRemoteDataSource {
  Future<void> blockUser(int userId);
  Future<void> unblockUser(int userId);
}

@LazySingleton(as: IModerationRemoteDataSource)
class ModerationRemoteDataSource implements IModerationRemoteDataSource {
  ModerationRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<void> blockUser(int userId) async {
    await _dioClient.post<void>(
      '/users/$userId/block',
      data: <String, dynamic>{},
    );
  }

  @override
  Future<void> unblockUser(int userId) async {
    await _dioClient.delete<void>(
      '/users/$userId/block',
    );
  }
}