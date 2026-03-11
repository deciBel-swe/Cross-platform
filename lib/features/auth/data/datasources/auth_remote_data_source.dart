import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart' as g_sign_in;
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/device_info_model.dart';
import '../models/login_response_model.dart';

abstract class IAuthRemoteDataSource {
  Future<LoginResponseModel> loginWithGoogle(DeviceInfoModel deviceInfo);
}

@LazySingleton(as: IAuthRemoteDataSource)
class AuthRemoteDataSource implements IAuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<LoginResponseModel> loginWithGoogle(DeviceInfoModel deviceInfo) async {
    final bool isMobile =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);

    if (isMobile) {
      // MOBILE: Use official Google Sign In SDK (In-App Popup) // why I used this instead of browser google is very strict I couldn't redirect to the app
      // It wasted alot of time so I decided to do this approach
      // This completely bypasses all the manual "Custom URI Scheme" redirect errors
      final String clientId =
          '767709617177-l61vbedk9lanvrgirt6e0840a4kijs6u.apps.googleusercontent.com';

      await g_sign_in.GoogleSignIn.instance.initialize(
        clientId: clientId,
        serverClientId:
            '767709617177-ljng08734ds2qv9m7qcrpccpe6igu9if.apps.googleusercontent.com', // Needed for backend code exchange
      );

      // Force interactive consent so we always get the serverAuthCode
      // so here this is done to avoid google from siging user in automatically
      // we need the auth code to send it to our backend to get the access token and refresh token
      // yes google knows the user but we don't lol
      await g_sign_in.GoogleSignIn.instance.signOut();
      final account = await g_sign_in.GoogleSignIn.instance.authenticate(
        scopeHint: ['email', 'profile'],
      );

      // The critical Server Auth Code needed for the Spring Boot backend
      final authz = await account.authorizationClient.authorizeServer([
        'email',
        'profile',
      ]);

      final authCode = authz?.serverAuthCode;

      if (authCode == null) {
        throw const AuthException('Failed to obtain Google Server Auth Code');
      }

      return _exchangeCodeWithBackend(authCode);
    } else {
      // DESKTOP: Use local HTTP server loopback
      // so for desktop I am making a local server that listens to the redirect uri
      // and then exchanges the code with our backend
      // I was trying to do the same for the android but google restricting opeing apps from links not easy
      final completer = Completer<LoginResponseModel>();

      final String clientId =
          '767709617177-ljng08734ds2qv9m7qcrpccpe6igu9if.apps.googleusercontent.com';
      final String redirectUri =
          'http://localhost:3000/login/oauth2/code/google';

      final authUrl = Uri.parse(
        'https://accounts.google.com/o/oauth2/v2/auth'
        '?client_id=$clientId'
        '&redirect_uri=$redirectUri'
        '&response_type=code'
        '&scope=email%20profile',
      );

      HttpServer? localServer;
      try {
        localServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 3000);

        // Listen to single incoming request on the localhost server
        localServer.listen((HttpRequest request) async {
          final uri = request.uri;

          // Check if it's the OAuth redirect path
          if (uri.path == '/login/oauth2/code/google' || uri.path == '/') {
            final authCode = uri.queryParameters['code'];
            final error = uri.queryParameters['error'];

            if (authCode != null) {
              // Serve a success page and close
              request.response
                ..statusCode = 200
                ..headers.contentType = ContentType.html
                ..write(
                  '<html><body><h2>Authentication complete! You can close this tab and return to Decibel.</h2></body></html>',
                );
              await request.response.close();
              await localServer?.close(force: true);

              // Exchange the code with our backend
              try {
                final model = await _exchangeCodeWithBackend(authCode);
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

  /// Here I communicate with the backend to exchange the auth code for tokens
  /// - Parameter [authCode]: The one-time server code retrieved from the Google Sign-In SDK.
  ///
  /// - Returns: A [LoginResponseModel] containing the newly generated access token,
  ///   refresh token, and the user's profile data.
  ///
  /// - Throws [ServerException] if the backend rejects the request (e.g., code expired)
  ///   or if there is a network connectivity issue.
  /// - Throws [AuthException] if the server returns an unexpected response format
  ///   or an unknown client-side error occurs.
  Future<LoginResponseModel> _exchangeCodeWithBackend(String authCode) async {
    try {
      final response = await _dio.post(
        ApiConstants.googleTokenExchangeEndpoint,
        data: {'code': authCode},
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
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map<String, dynamic>
          ? data['message'] as String?
          : null;

      throw ServerException(
        message ??
            'A network error occurred during login. Status code: ${e.response?.statusCode}',
      );
    } catch (e) {
      throw AuthException(
        'An unexpected error occurred during Google Sign In verify: $e',
      );
    }
  }
}
