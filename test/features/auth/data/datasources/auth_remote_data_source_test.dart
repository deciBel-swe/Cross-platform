import 'package:decibel/core/constants/api_constants.dart';
import 'package:decibel/core/network/dio_client.dart';
import 'package:decibel/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:decibel/features/auth/data/models/device_info_model.dart';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late MockDioClient mockDioClient;
  late AuthRemoteDataSource dataSource;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = AuthRemoteDataSource(mockDioClient);
  });

  group('AuthRemoteDataSource exchangeCodeWithBackend', () {
    const tAuthCode = 'test_auth_code';
    const tDeviceInfo = DeviceInfoModel(
      deviceType: 'DESKTOP',
      fingerPrint: 'test_fingerprint',
      deviceName: 'test',
    );

    final tLoginResponseJson = {
      'data': {
        'accessToken': 'access_token_123',
        'expiresIn': 3600,
        'user': {'id': 1, 'username': 'test_user', 'tier': 'FREE'}
      }
    };

    final tResponseHeaders = Headers.fromMap({
      'set-cookie': [
        'refreshToken=refresh_token_123; Path=/auth; HttpOnly; SameSite=Lax',
        'otherCookie=value'
      ],
      'content-type': ['application/json']
    });

    test(
      'should extract refreshToken from set-cookie header and return LoginResponseModel',
      () async {
        // Arrange
        when(
          () => mockDioClient.post<dynamic>(
            ApiConstants.googleTokenExchangeEndpoint,
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: ApiConstants.googleTokenExchangeEndpoint,
            ),
            statusCode: 200,
            data: tLoginResponseJson,
            headers: tResponseHeaders,
          ),
        );

        // Act
        final result = await dataSource.exchangeCodeWithBackend(
          tAuthCode,
          tDeviceInfo,
        );

        // Assert
        expect(result.accessToken, 'access_token_123');
        expect(result.refreshToken, 'refresh_token_123'); // Custom extraction
        expect(result.expiresIn, 3600);
        expect(result.user.username, 'test_user');
      },
    );

    test(
      'should fallback to plain body parsing without data envelope',
      () async {
        // Arrange
        final flatJson = {
          'accessToken': 'access_token_flat',
          'expiresIn': 1800,
          'user': {'id': 2, 'username': 'flat_user', 'tier': 'FREE'}
        };

        when(
          () => mockDioClient.post<dynamic>(
            ApiConstants.googleTokenExchangeEndpoint,
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: ApiConstants.googleTokenExchangeEndpoint,
            ),
            statusCode: 200,
            data: flatJson,
            headers: Headers(),
          ),
        );

        // Act
        final result = await dataSource.exchangeCodeWithBackend(
          tAuthCode,
          tDeviceInfo,
        );

        // Assert
        expect(result.accessToken, 'access_token_flat');
        expect(result.refreshToken, isNull); // No cookie provided
        expect(result.user.username, 'flat_user');
      },
    );
  });
}
