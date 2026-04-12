import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart' as g_sign_in;
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/device_info_model.dart';
import '../models/login_local_request_model.dart';
import '../models/login_response_model.dart';
import '../models/oauth_exchange_request_dto.dart';
import '../models/refresh_token_response_model.dart';
import '../models/register_local_request_model.dart';
import '../utils/auth_success_page.dart';

abstract class IAuthRemoteDataSource {
  Future<LoginResponseModel> loginLocal(LoginLocalRequestModel request);
  Future<void> registerLocal(RegisterLocalRequestModel request);
  Future<LoginResponseModel> loginWithGoogle(DeviceInfoModel deviceInfo);
  Future<RefreshTokenResponseModel> refreshToken({
    required String refreshToken,
    required String accessToken,
  });
  Future<void> logout();
}

@LazySingleton(as: IAuthRemoteDataSource)
class AuthRemoteDataSource implements IAuthRemoteDataSource {
  AuthRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<LoginResponseModel> loginLocal(LoginLocalRequestModel request) async {
    try {
      final payload = <String, dynamic>{
        'email': request.email,
        'password': request.password,
        'deviceInfo': request.deviceInfo.toJson(),
      };

      final response = await _dioClient.post<dynamic>(
        ApiConstants.localLoginEndpoint,
        data: payload,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw AuthException(
          _parseManualError(response.data, fallback: 'Login failed'),
        );
      }

      return _parseLoginResponse(response);
    } on DioException catch (e) {
      throw ServerException(
        _extractDioErrorMessage(e, fallback: 'Login failed'),
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw AuthException('An unexpected error occurred during login: $e');
    }
  }

  @override
  Future<void> registerLocal(RegisterLocalRequestModel request) async {
    try {
      final response = await _dioClient.post<dynamic>(
        ApiConstants.localRegisterEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw AuthException(
          _parseManualError(response.data, fallback: 'Registration failed'),
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        _extractDioErrorMessage(e, fallback: 'Registration failed'),
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw AuthException(
        'An unexpected error occurred during registration: $e',
      );
    }
  }

  @override
  Future<LoginResponseModel> loginWithGoogle(DeviceInfoModel deviceInfo) async {
    final bool isMobile =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);

    if (isMobile) {
      try {
        await g_sign_in.GoogleSignIn.instance.initialize(
          serverClientId: ApiConstants.googleDesktopClientId,
        );
        // I removed the signOut call as it causes crashes from google credential center for some weird reason

        // Trigger the Android 14 Credential Manager bottom sheet
        final account = await g_sign_in.GoogleSignIn.instance.authenticate(
          scopeHint: ['email', 'profile'],
        );

        // Request Authorization (the server auth code for the backend)
        final authz = await account.authorizationClient.authorizeServer([
          'email',
          'profile',
        ]);

        final authCode = authz?.serverAuthCode;

        if (authCode == null) {
          throw const AuthException('Failed to obtain Google Server Auth Code');
        }

        return await exchangeCodeWithBackend(authCode, deviceInfo);
      } on PlatformException catch (e) {
        if (e.code == 'sign_in_canceled') {
          throw const AuthException('Sign in was canceled by the user.');
        }
        throw AuthException('Google Sign In failed: ${e.message}');
      }
    } else {
      // DESKTOP: Use local HTTP server loopback
      final completer = Completer<LoginResponseModel>();

      final clientId = ApiConstants.googleDesktopClientId;
      const redirectUri = ApiConstants.googleDesktopRedirectUri;

      final authUrl = Uri.parse(
        '${ApiConstants.googleAuthUrl}'
        '?client_id=$clientId'
        '&redirect_uri=$redirectUri'
        '&response_type=code'
        '&scope=email%20profile',
      );

      // Early error check: pre-flight the auth URL
      try {
        final checkResponse = await Dio().getUri<dynamic>(authUrl);
        if (checkResponse.realUri.toString().contains('oauth/error')) {
          return Future.error(
            const AuthException('error while loging with google'),
          );
        }
      } on DioException catch (e) {
        if (e.response?.realUri.toString().contains('oauth/error') == true) {
          return Future.error(
            const AuthException('error while loging with google'),
          );
        }
      } catch (_) {
        // Ignored, proceed to normal flow if the check fails for some other reason
      }

      HttpServer? localServer;
      try {
        localServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 8081);

        // Listen to single incoming request on the localhost server
        localServer.listen((HttpRequest request) async {
          final uri = request.uri;

          // Check if it's the OAuth redirect path
          if (uri.path == '/login/oauth2/code/google' || uri.path == '/') {
            final authCode =
                uri.queryParameters['token'] ?? uri.queryParameters['code'];
            final error = uri.queryParameters['error'];

            if (authCode != null) {
              // Serve a branded success page and close
              final html = await buildAuthSuccessHtml();

              request.response
                ..statusCode = 200
                ..headers.contentType = ContentType.html
                ..write(html);
              await request.response.close();
              await localServer?.close(force: true);

              // Exchange the code with our backend
              try {
                final model = await exchangeCodeWithBackend(
                  authCode,
                  deviceInfo,
                );
                if (!completer.isCompleted) {
                  completer.complete(model);
                }
              } catch (e) {
                if (!completer.isCompleted) {
                  completer.completeError(AuthException(e.toString()));
                }
              }
            } else if (error != null) {
              request.response
                ..statusCode = 400
                ..write('Error: $error');
              await request.response.close();
              await localServer?.close(force: true);
              if (!completer.isCompleted) {
                completer.completeError(
                  AuthException('Google Auth Error: $error'),
                );
              }
            } else {
              request.response
                ..statusCode = 400
                ..write('Missing auth code');
              await request.response.close();
              await localServer?.close(force: true);
              if (!completer.isCompleted) {
                completer.completeError(
                  const AuthException('No code returned from redirect'),
                );
              }
            }
          }
        });
      } catch (e) {
        if (!completer.isCompleted) {
          completer.completeError(
            AuthException('Could not start local server on port 3000: $e'),
          );
        }
        return completer.future;
      }

      try {
        final launched = await launchUrl(
          authUrl,
          mode: LaunchMode.externalApplication,
        );

        if (!launched) {
          await localServer.close(force: true);
          if (!completer.isCompleted) {
            completer.completeError(
              const AuthException(
                'Could not launch browser for Google Sign In.',
              ),
            );
          }
        }
      } catch (e) {
        await localServer.close(force: true);
        if (!completer.isCompleted) {
          completer.completeError(
            AuthException('Failed to launch the browser: $e'),
          );
        }
      }

      return completer.future;
    }
  }

  @override
  Future<RefreshTokenResponseModel> refreshToken({
    required String refreshToken,
    required String accessToken,
  }) async {
    try {
      final cookieHeader =
          'refreshToken=$refreshToken; accessToken=$accessToken';

      final response = await _dioClient.post<dynamic>(
        ApiConstants.refreshTokenEndpoint,
        data: {'refreshToken': refreshToken},
        options: Options(headers: {'Cookie': cookieHeader}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw AuthException(
          _parseManualError(response.data, fallback: 'Token refresh failed'),
        );
      }

      return _parseRefreshTokenResponse(response);
    } on DioException catch (e) {
      throw ServerException(
        _extractDioErrorMessage(e, fallback: 'Token refresh failed'),
      );
    } catch (e) {
      throw AuthException(
        'An unexpected error occurred during token refresh: $e',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await _dioClient.post<dynamic>(
        ApiConstants.logoutEndpoint,
        data: const <String, dynamic>{},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw AuthException(
          'Backend returned an error. Status Code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        'A network error occurred during logout: ${e.message}',
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw AuthException('An unexpected error occurred during logout: $e');
    }
  }

  @visibleForTesting
  Future<LoginResponseModel> exchangeCodeWithBackend(
    String authCode,
    DeviceInfoModel deviceInfo,
  ) async {
    try {
      final dto = OauthExchangeRequestDto(
        code: authCode,
        deviceInfo: deviceInfo,
      );
      if (kDebugMode) {
        debugPrint('=== OAUTH BACKEND PAYLOAD ===');
        debugPrint(jsonEncode(dto.toApiJson()));
        debugPrint('=============================');
      }

      final response = await _dioClient.post<dynamic>(
        ApiConstants.googleTokenExchangeEndpoint,
        data: dto.toApiJson(),
      );

      if (kDebugMode) {
        debugPrint('=== OAUTH BACKEND RESPONSE ===');
        debugPrint('Status: ${response.statusCode}');
        debugPrint(jsonEncode(response.data));
        debugPrint('==============================');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return _parseLoginResponse(response);
      } else {
        throw AuthException(
          'Backend returned an error. Status Code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        'A network error occurred during login: ${e.message}',
      );
    } catch (e) {
      throw AuthException(
        'An unexpected error occurred during Google Sign In: $e',
      );
    }
  }

  LoginResponseModel _parseLoginResponse(Response<dynamic> response) {
    final body = response.data;

    Map<String, dynamic> dataMap;
    if (body is Map<String, dynamic> && body['data'] != null) {
      dataMap = Map<String, dynamic>.from(body['data'] as Map);
    } else if (body is Map<String, dynamic>) {
      dataMap = Map<String, dynamic>.from(body);
    } else {
      throw const AuthException('Invalid response format from server.');
    }

    final cookies = response.headers.map['set-cookie'] ?? <String>[];
    String? extractedRefreshToken;
    String? extractedAccessToken;

    for (final cookie in cookies) {
      final parts = cookie.split(';');
      for (final part in parts) {
        final trimmed = part.trim();
        if (trimmed.startsWith('refreshToken=')) {
          extractedRefreshToken = trimmed.substring('refreshToken='.length);
        } else if (trimmed.startsWith('accessToken=')) {
          extractedAccessToken = trimmed.substring('accessToken='.length);
        }
      }
    }

    if (extractedRefreshToken != null && extractedRefreshToken.isNotEmpty) {
      dataMap['refreshToken'] = extractedRefreshToken;
    }
    if (extractedAccessToken != null && extractedAccessToken.isNotEmpty) {
      dataMap['accessToken'] = extractedAccessToken;
    }

    return LoginResponseModel.fromJson(dataMap);
  }

  RefreshTokenResponseModel _parseRefreshTokenResponse(
    Response<dynamic> response,
  ) {
    final body = response.data;

    Map<String, dynamic> dataMap;
    if (body is Map<String, dynamic> && body['data'] != null) {
      dataMap = Map<String, dynamic>.from(body['data'] as Map);
    } else if (body is Map<String, dynamic>) {
      dataMap = Map<String, dynamic>.from(body);
    } else {
      throw const AuthException('Invalid refresh response format from server.');
    }

    final cookies = response.headers.map['set-cookie'] ?? <String>[];
    String? extractedRefreshToken;

    for (final cookie in cookies) {
      final parts = cookie.split(';');
      for (final part in parts) {
        final trimmed = part.trim();
        if (trimmed.startsWith('refreshToken=')) {
          extractedRefreshToken = trimmed.substring('refreshToken='.length);
        }
      }
    }

    final accessToken = dataMap['accessToken'];
    final expiresInRaw = dataMap['expiresIn'];

    if (accessToken is! String || accessToken.isEmpty) {
      throw const AuthException('Missing access token in refresh response.');
    }

    final expiresIn = switch (expiresInRaw) {
      int value => value,
      String value => int.tryParse(value),
      _ => null,
    };

    if (expiresIn == null || expiresIn <= 0) {
      throw const AuthException(
        'Missing or invalid expiresIn in refresh response.',
      );
    }

    return RefreshTokenResponseModel(
      accessToken: accessToken,
      expiresIn: expiresIn,
      refreshToken: extractedRefreshToken,
    );
  }

  String _parseManualError(Object? data, {required String fallback}) {
    if (data is Map<String, dynamic>) {
      final parsed = _parseErrorMap(data);
      if (parsed != null) return parsed;
    }
    return fallback;
  }

  String _extractDioErrorMessage(DioException e, {required String fallback}) {
    final data = e.response?.data;
    final statusCode = e.response?.statusCode;

    if (statusCode == 401) {
      return 'Incorrect email or password.';
    }

    if (data is Map<String, dynamic>) {
      final parsed = _parseErrorMap(data);
      if (parsed != null) return parsed;
    }

    final fallbackMessage = e.message?.trim();
    if (fallbackMessage != null && fallbackMessage.isNotEmpty) {
      return '$fallback: $fallbackMessage';
    }

    return fallback;
  }

  String? _parseErrorMap(Map<String, dynamic> data) {
    final errors = data['errors'];
    if (errors is Map<String, dynamic>) {
      final List<String> fieldErrors = [];

      errors.forEach((key, value) {
        if (value is List) {
          fieldErrors.add(value.join('\n'));
        } else {
          fieldErrors.add(value.toString());
        }
      });

      if (fieldErrors.isNotEmpty) {
        return fieldErrors.join('\n');
      }
    }

    final messageData = data['message'];
    if (messageData is List && messageData.isNotEmpty) {
      return messageData.join('\n');
    }

    if (messageData is String && messageData.trim().isNotEmpty) {
      return messageData.trim();
    }

    final nestedData = data['data'];
    if (nestedData is Map<String, dynamic>) {
      final nestedMessage = nestedData['message'];
      if (nestedMessage is String && nestedMessage.trim().isNotEmpty) {
        return nestedMessage.trim();
      }
    }

    return null;
  }
}
