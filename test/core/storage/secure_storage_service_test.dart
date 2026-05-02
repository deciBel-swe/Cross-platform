import 'dart:convert';
import 'package:decibel/core/storage/secure_storage_service.dart';
import 'package:decibel/features/auth/data/models/auth_user_model.dart';
import 'package:decibel/features/auth/data/models/login_response_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late SecureStorageService service;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    service = SecureStorageService(mockStorage);
  });

  group('SecureStorageService', () {
    const tUser = AuthUserModel(
      id: 1,
      username: 'test',
      tier: 'FREE',
    );

    const tLoginResponse = LoginResponseModel(
      accessToken: 'access',
      refreshToken: 'refresh',
      expiresIn: 3600,
      user: tUser,
    );

    test('saveTokenPair should write tokens and user to storage', () async {
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async => {});

      await service.saveTokenPair(tLoginResponse);

      verify(() => mockStorage.write(key: 'access_token', value: 'access')).called(1);
      verify(() => mockStorage.write(key: 'refresh_token', value: 'refresh')).called(1);
      verify(() => mockStorage.write(key: 'auth_user', value: jsonEncode(tUser.toJson()))).called(1);
    });

    test('updateUser should write user to storage', () async {
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async => {});

      await service.updateUser(tUser);

      verify(() => mockStorage.write(key: 'auth_user', value: jsonEncode(tUser.toJson()))).called(1);
    });

    test('getUser should return AuthUserModel when present', () async {
      when(() => mockStorage.read(key: 'auth_user'))
          .thenAnswer((_) async => jsonEncode(tUser.toJson()));

      final result = await service.getUser();

      expect(result, tUser);
    });

    test('getUser should return null when absent', () async {
      when(() => mockStorage.read(key: 'auth_user')).thenAnswer((_) async => null);

      final result = await service.getUser();

      expect(result, isNull);
    });

    test('getString/setString/removeString should call underlying storage', () async {
      when(() => mockStorage.read(key: 'key')).thenAnswer((_) async => 'value');
      when(() => mockStorage.write(key: 'key', value: 'value')).thenAnswer((_) async => {});
      when(() => mockStorage.delete(key: 'key')).thenAnswer((_) async => {});

      expect(await service.getString('key'), 'value');
      await service.setString('key', 'value');
      await service.removeString('key');

      verify(() => mockStorage.read(key: 'key')).called(1);
      verify(() => mockStorage.write(key: 'key', value: 'value')).called(1);
      verify(() => mockStorage.delete(key: 'key')).called(1);
    });

    test('clearAll should call deleteAll', () async {
      when(() => mockStorage.deleteAll()).thenAnswer((_) async => {});

      await service.clearAll();

      verify(() => mockStorage.deleteAll()).called(1);
    });
  });
}
