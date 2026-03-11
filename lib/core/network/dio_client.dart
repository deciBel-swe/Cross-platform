import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../constants/api_constants.dart';

@lazySingleton
class DioClient {
  final Dio _dio;
  DioClient(this._dio){
    _dio.options
      ..baseUrl = ApiConstants.baseUrl
      ..connectTimeout = const Duration(milliseconds: ApiConstants.connectTimeout)
      ..receiveTimeout = const Duration(milliseconds: ApiConstants.receiveTimeout)
      ..contentType = 'application/json';

      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );
  }

  // Helper method for GET requests
  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParams}){
    return _dio.get(path, queryParameters: queryParams);
  }

  // Helper method for POST requests
  Future<Response<T>> post<T>(String path, {object? data}){
    return _dio.post(path, data: data);
  }

  // Helper method for PUT requests
  Future<Response<T>> put<T>(String path,{object? data}){
    return _dio.put(path, data: data);
  }

  // Helper method for DELETE requests
  Future<Response<T>> delete<T>(String path, {Map<String, object>? queryParams}){
    return _dio.delete(path);
  }
}
