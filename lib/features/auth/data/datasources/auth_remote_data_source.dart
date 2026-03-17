import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart' as g_sign_in;
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/device_info_model.dart';
import '../models/login_response_model.dart';
import '../models/oauth_exchange_request_dto.dart';
import '../utils/auth_success_page.dart';

abstract class IAuthRemoteDataSource {
  Future<LoginResponseModel> loginWithGoogle(DeviceInfoModel deviceInfo);

  Future<void> forgotPassword(String email);

  Future<void> resendVerification(String email);
}

@LazySingleton(as: IAuthRemoteDataSource)
class AuthRemoteDataSource implements IAuthRemoteDataSource {
  AuthRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<LoginResponseModel> loginWithGoogle(DeviceInfoModel deviceInfo) async {
    final bool isMobile =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);

    if (isMobile) {
      const String clientId = ApiConstants.googleMobileClientId;

      await g_sign_in.GoogleSignIn.instance.initialize(
        clientId: clientId,
        serverClientId: ApiConstants.googleDesktopClientId,
      );

      await g_sign_in.GoogleSignIn.instance.signOut();
      final account = await g_sign_in.GoogleSignIn.instance.authenticate(
        scopeHint: ['email', 'profile'],
      );

      final authz = await account.authorizationClient.authorizeServer([
        'email',
        'profile',
      ]);

      final String? authCode = authz?.serverAuthCode;

      if (authCode == null) {
        throw const AuthException('Failed to obtain Google Server Auth Code');
      }

      return _exchangeCodeWithBackend(authCode, deviceInfo);
    } else {
      final Completer<LoginResponseModel> completer =
          Completer<LoginResponseModel>();

      const String clientId = ApiConstants.googleDesktopClientId;
      const String redirectUri = ApiConstants.googleDesktopRedirectUri;

      final Uri authUrl = Uri.parse(
        '${ApiConstants.googleAuthUrl}'
        '?client_id=$clientId'
        '&redirect_uri=$redirectUri'
        '&response_type=code'
        '&scope=email%20profile',
      );

      HttpServer? localServer;
      try {
        localServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 3000);

        localServer.listen((HttpRequest request) async {
          final Uri uri = request.uri;

          if (uri.path == '/login/oauth2/code/google' || uri.path == '/') {
            final String? authCode = uri.queryParameters['code'];
            final String? error = uri.queryParameters['error'];

            if (authCode != null) {
              final String html = await buildAuthSuccessHtml();

              request.response
                ..statusCode = 200
                ..headers.contentType = ContentType.html
                ..write(html);

              await request.response.close();
              await localServer?.close(force: true);

              try {
                final LoginResponseModel model = await _exchangeCodeWithBackend(
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
        final bool launched = await launchUrl(
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
  Future<void> forgotPassword(String email) async {
    try {
      final response = await _dioClient.post<dynamic>(
        ApiConstants.forgotPasswordEndpoint,
        data: <String, dynamic>{'email': email},
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return;
      }

      throw const AuthException('Failed to send reset link. Please try again.');
    } catch (e) {
      if (e.toString().contains('DioException')) {
        throw const ServerException(
          'A network error occurred while sending the reset link.',
        );
      }

      if (e is AppException) {
        rethrow;
      }

      throw AuthException(
        'An unexpected error occurred while sending the reset link: $e',
      );
    }
  }

  @override
  Future<void> resendVerification(String email) async {
    try {
      final response = await _dioClient.post<dynamic>(
        ApiConstants.resendVerificationEndpoint,
        data: <String, dynamic>{'email': email},
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return;
      }

      throw const AuthException(
        'Failed to resend verification email. Please try again.',
      );
    } catch (e) {
      if (e.toString().contains('DioException')) {
        throw const ServerException(
          'A network error occurred while resending verification email.',
        );
      }

      if (e is AppException) {
        rethrow;
      }

      throw AuthException(
        'An unexpected error occurred while resending verification email: $e',
      );
    }
  }

  Future<LoginResponseModel> _exchangeCodeWithBackend(
    String authCode,
    DeviceInfoModel deviceInfo,
  ) async {
    try {
      final OauthExchangeRequestDto dto = OauthExchangeRequestDto(
        code: authCode,
        deviceInfo: deviceInfo,
      );

      if (kDebugMode) {
        final payload = dto.toJson();

        debugPrint('=== OAUTH BACKEND PAYLOAD ===');
        debugPrint(jsonEncode(payload));
        debugPrint('=============================');
      }

      final response = await _dioClient.post<dynamic>(
        ApiConstants.googleTokenExchangeEndpoint,
        data: dto.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return LoginResponseModel.fromJson(data);
        } else {
          throw const AuthException('Invalid response format from server.');
        }
      } else {
        throw AuthException(
          'Backend returned an error. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e.toString().contains('DioException')) {
        throw const ServerException('A network error occurred during login.');
      }

      throw AuthException(
        'An unexpected error occurred during Google Sign In verify: $e',
      );
    }
  }
}
