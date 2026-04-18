import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/device_token_request.dart';

class DeviceTokenRegistrationService {
  DeviceTokenRegistrationService(this._api);

  final DioClient _api;

  Future<void> registerMobileToken(String token) async {
    final request = DeviceTokenRequest(
      token: token,
      deviceType: 'MOBILE',
    );

    await _api.post<Map<String, dynamic>>(
      ApiConstants.notificationDeviceTokensEndpoint,
      data: request.toJson(),
    );
  }
}