import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../models/listening_history_response.dart';

@lazySingleton
class HistoryRemoteDatasource {
  HistoryRemoteDatasource(this._dioClient);

  final DioClient _dioClient;

  Future<ListeningHistoryResponse> getListeningHistory({
    int page = 0,
    int size = 20,
  }) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '/users/me/history',
      queryParams: {
        'page': page,
        'size': size,
      },
    );

    return ListeningHistoryResponse.fromJson(response.data!);
  }
}