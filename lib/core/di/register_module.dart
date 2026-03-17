import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../constants/api_constants.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../storage/secure_storage_service.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );

  @lazySingleton
  Dio get dio => Dio();

  @lazySingleton
  ImagePicker get imagePicker => ImagePicker();

  /// Provides the [AuthInterceptor] for production environments.
  ///
  /// It creates a secondary, clean `Dio` instance (`refreshDio`)
  /// specifically for making the refresh token request without
  /// triggering the interceptor itself recursively.
  @lazySingleton
  @Environment(Environment.prod)
  AuthInterceptor getAuthInterceptor(SecureStorageService secureStorage) {
    final refreshDio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
        contentType: 'application/json',
      ),
    );
    // You may also want to add a logging interceptor to the refresh instance for debugging
    refreshDio.interceptors.add(LogInterceptor(responseBody: true));

    return AuthInterceptor(secureStorage, refreshDio: refreshDio);
  }
}
