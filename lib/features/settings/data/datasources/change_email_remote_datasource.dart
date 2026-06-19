import 'package:injectable/injectable.dart';

import '../../../../core/network/dio_client.dart';

@lazySingleton
class ChangeEmailRemoteDatasource {
  ChangeEmailRemoteDatasource(this._dioClient);

  final DioClient _dioClient;

  Future<String> changeEmail({required String newEmail}) async {
    final response = await _dioClient.patch<dynamic>(
      '/users/me/email',
      data: {"newEmail": newEmail},
    );

    final data = response.data;

    // 1. Check for a direct 'message' key
    if (data case {'message': final String message}) {
      return message;
    }
    
    // 2. Check for a nested 'message' key inside a 'data' object
    if (data case {'data': {'message': final String message}}) {
      return message;
    }

    // 3. Fallback if the structure doesn't match
    return data?.toString() ?? '';
  }
}