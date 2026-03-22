// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:google_sign_in/google_sign_in.dart' as g_sign_in;
// import 'package:injectable/injectable.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../../../core/constants/api_constants.dart';
// import '../../../../core/errors/exceptions.dart';
// import '../../../../core/network/dio_client.dart';
// import '../models/device_info_model.dart';
// import '../models/login_response_model.dart';
// import '../models/oauth_exchange_request_dto.dart';
// import '../utils/auth_success_page.dart';

// abstract class IAuthRemoteDataSource {
//   Future<LoginResponseModel> loginWithGoogle(DeviceInfoModel deviceInfo);
// }

// @LazySingleton(as: IAuthRemoteDataSource)
// class AuthRemoteDataSource implements IAuthRemoteDataSource {
//   AuthRemoteDataSource(this._dioClient);

//   final DioClient _dioClient;

//   @override
//   Future<LoginResponseModel> loginWithGoogle(DeviceInfoModel deviceInfo) async {
//     final bool isMobile =
//         !kIsWeb &&
//         (defaultTargetPlatform == TargetPlatform.android ||
//             defaultTargetPlatform == TargetPlatform.iOS);

//     if (isMobile) {
//       // MOBILE: Use official Google Sign In SDK (In-App Popup) // why I used this instead of browser google is very strict I couldn't redirect to the app
//       // It wasted alot of time so I decided to do this approach
//       // This completely bypasses all the manual "Custom URI Scheme" redirect errors
//       //const String clientId = ApiConstants.googleMobileClientId;

//       await g_sign_in.GoogleSignIn.instance.initialize(
//         //clientId: clientId,
//         serverClientId: ApiConstants
//             .googleDesktopClientId, // Needed for backend code exchange
//       );

//       // Force interactive consent so we always get the serverAuthCode
//       // so here this is done to avoid google from siging user in automatically
//       // we need the auth code to send it to our backend to get the access token and refresh token
//       // yes google knows the user but we don't lol
//       //await g_sign_in.GoogleSignIn.instance.signOut();
//       final account = await g_sign_in.GoogleSignIn.instance.authenticate(
//         scopeHint: ['email', 'profile'],
//       );

//       // The critical Server Auth Code needed for the Spring Boot backend
//       final authz = await account.authorizationClient.authorizeServer([
//         'email',
//         'profile',
//       ]);

//       final authCode = authz?.serverAuthCode;

//       if (authCode == null) {
//         throw const AuthException('Failed to obtain Google Server Auth Code');
//       }

//       return _exchangeCodeWithBackend(authCode, deviceInfo);
//     } else {
//       // DESKTOP: Use local HTTP server loopback
//       // so for desktop I am making a local server that listens to the redirect uri
//       // and then exchanges the code with our backend
//       // I was trying to do the same for the android but google restricting opeing apps from links not easy
//       final completer = Completer<LoginResponseModel>();

//       const String clientId = ApiConstants.googleDesktopClientId;
//       const String redirectUri = ApiConstants.googleDesktopRedirectUri;

//       final authUrl = Uri.parse(
//         '${ApiConstants.googleAuthUrl}'
//         '?client_id=$clientId'
//         '&redirect_uri=$redirectUri'
//         '&response_type=code'
//         '&scope=email%20profile',
//       );

//       HttpServer? localServer;
//       try {
//         localServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 3000);

//         // Listen to single incoming request on the localhost server
//         localServer.listen((HttpRequest request) async {
//           final uri = request.uri;

//           // Check if it's the OAuth redirect path
//           if (uri.path == '/login/oauth2/code/google' || uri.path == '/') {
//             final authCode = uri.queryParameters['code'];
//             final error = uri.queryParameters['error'];

//             if (authCode != null) {
//               // Serve a branded success page and close
//               final html = await buildAuthSuccessHtml();

//               request.response
//                 ..statusCode = 200
//                 ..headers.contentType = ContentType.html
//                 ..write(html);
//               await request.response.close();
//               await localServer?.close(force: true);

//               // Exchange the code with our backend
//               try {
//                 final model = await _exchangeCodeWithBackend(
//                   authCode,
//                   deviceInfo,
//                 );
//                 if (!completer.isCompleted) {
//                   completer.complete(model);
//                 }
//               } catch (e) {
//                 if (!completer.isCompleted) {
//                   completer.completeError(AuthException(e.toString()));
//                 }
//               }
//             } else if (error != null) {
//               request.response
//                 ..statusCode = 400
//                 ..write('Error: $error');
//               await request.response.close();
//               await localServer?.close(force: true);
//               if (!completer.isCompleted) {
//                 completer.completeError(
//                   AuthException('Google Auth Error: $error'),
//                 );
//               }
//             } else {
//               request.response
//                 ..statusCode = 400
//                 ..write('Missing auth code');
//               await request.response.close();
//               await localServer?.close(force: true);
//               if (!completer.isCompleted) {
//                 completer.completeError(
//                   const AuthException('No code returned from redirect'),
//                 );
//               }
//             }
//           }
//         });
//       } catch (e) {
//         if (!completer.isCompleted) {
//           completer.completeError(
//             AuthException('Could not start local server on port 3000: $e'),
//           );
//         }
//         return completer.future;
//       }

//       try {
//         final launched = await launchUrl(
//           authUrl,
//           mode: LaunchMode.externalApplication,
//         );

//         if (!launched) {
//           await localServer.close(force: true);
//           if (!completer.isCompleted) {
//             completer.completeError(
//               const AuthException(
//                 'Could not launch browser for Google Sign In.',
//               ),
//             );
//           }
//         }
//       } catch (e) {
//         await localServer.close(force: true);
//         if (!completer.isCompleted) {
//           completer.completeError(
//             AuthException('Failed to launch the browser: $e'),
//           );
//         }
//       }

//       return completer.future;
//     }
//   }

//   /// Here I communicate with the backend to exchange the auth code for tokens
//   /// - Parameter [authCode]: The one-time server code retrieved from the Google Sign-In SDK.
//   ///
//   /// - Returns: A [LoginResponseModel] containing the newly generated access token,
//   ///   refresh token, and the user's profile data.
//   ///
//   /// - Throws [ServerException] if the backend rejects the request (e.g., code expired)
//   ///   or if there is a network connectivity issue.
//   /// - Throws [AuthException] if the server returns an unexpected response format
//   ///   or an unknown client-side error occurs.
//   Future<LoginResponseModel> _exchangeCodeWithBackend(
//     String authCode,
//     DeviceInfoModel deviceInfo,
//   ) async {
//     try {
//       final dto = OauthExchangeRequestDto(
//         code: authCode,
//         deviceInfo: deviceInfo,
//       );
//       if (kDebugMode) {
//         debugPrint('=== OAUTH BACKEND PAYLOAD ===');
//         debugPrint(jsonEncode(dto.toApiJson()));
//         debugPrint('=============================');
//       }

//       final response = await _dioClient.post<dynamic>(
//         ApiConstants.googleTokenExchangeEndpoint,
//         data: dto.toApiJson(),
//       );

//       if (kDebugMode) {
//         debugPrint('=== OAUTH BACKEND RESPONSE ===');
//         debugPrint('Status: ${response.statusCode}');
//         debugPrint(jsonEncode(response.data));
//         debugPrint('==============================');
//       }

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final body = response.data;
//         if (body is Map<String, dynamic> && body['data'] != null) {
//           final dataMap = body['data'] as Map<String, dynamic>;
//           return LoginResponseModel.fromJson(dataMap);
//         } else if (body is Map<String, dynamic>) {
//           // Fallback in case the backend doesn't wrap the specific endpoint
//           return LoginResponseModel.fromJson(body);
//         } else {
//           throw const AuthException('Invalid response format from server.');
//         }
//       } else {
//         throw AuthException(
//           'Backend returned an error. Status Code: ${response.statusCode}',
//         );
//       }
//     } on DioException catch (e) {
//       throw ServerException(
//         'A network error occurred during login: ${e.message}',
//       );
//     } catch (e) {
//       throw AuthException(
//         'An unexpected error occurred during Google Sign In: $e',
//       );
//     }
//   }
// }
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
import '../models/login_response_model.dart';
import '../models/oauth_exchange_request_dto.dart';
import '../utils/auth_success_page.dart';

abstract class IAuthRemoteDataSource {
  Future<LoginResponseModel> loginWithGoogle(DeviceInfoModel deviceInfo);
  Future<void> logout();
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
      try {
        // v7+ API: Initialize the singleton instance.
        // CRITICAL: We DO NOT pass the clientId parameter here for Android.
        // We only pass the Web Client ID into serverClientId to get the backend auth code.
        await g_sign_in.GoogleSignIn.instance.initialize(
          serverClientId: ApiConstants.googleDesktopClientId,
        );

        // NOTE: Do not call signOut() here. Doing so immediately before authenticate()
        // causes the Android Credential Manager to crash with "[16] Account reauth failed".

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

        return await _exchangeCodeWithBackend(authCode, deviceInfo);
      } on PlatformException catch (e) {
        if (e.code == 'sign_in_canceled') {
          throw const AuthException('Sign in was canceled by the user.');
        }
        throw AuthException('Google Sign In failed: ${e.message}');
      }
    } else {
      // DESKTOP: Use local HTTP server loopback
      final completer = Completer<LoginResponseModel>();

      final authUrl = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.googleAuthEndpoint}',
      );

      HttpServer? localServer;
      try {
        localServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 3000);

        // Listen to single incoming request on the localhost server
        localServer.listen((HttpRequest request) async {
          final uri = request.uri;

          // Check if it's the OAuth redirect path
          if (uri.path == '/login/oauth2/code/google' || uri.path == '/') {
            final authCode = uri.queryParameters['token'] ?? uri.queryParameters['code'];
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
                final model = await _exchangeCodeWithBackend(
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
  Future<void> logout() async {
    try {
      final response = await _dioClient.post<dynamic>(
        ApiConstants.logoutEndpoint,
        data: const <String, dynamic>{},
      );

      if (response.statusCode != 204) {
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

  /// Here I communicate with the backend to exchange the auth code for tokens
  Future<LoginResponseModel> _exchangeCodeWithBackend(
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
        // Extract refreshToken from cookies
        final cookies = response.headers.map['set-cookie'] ?? <String>[];
        String? extractedRefreshToken;
        for (final cookie in cookies) {
          if (cookie.contains('refreshToken=')) {
            final parts = cookie.split(';');
            for (final part in parts) {
              final trimmed = part.trim();
              if (trimmed.startsWith('refreshToken=')) {
                extractedRefreshToken =
                    trimmed.substring('refreshToken='.length);
                break;
              }
            }
          }
          if (extractedRefreshToken != null) break;
        }

        final body = response.data;
        Map<String, dynamic> dataMap;
        if (body is Map<String, dynamic> && body['data'] != null) {
          dataMap = Map<String, dynamic>.from(body['data'] as Map);
        } else if (body is Map<String, dynamic>) {
          // Fallback in case the backend doesn't wrap the specific endpoint
          dataMap = Map<String, dynamic>.from(body);
        } else {
          throw const AuthException('Invalid response format from server.');
        }

        if (extractedRefreshToken != null) {
          dataMap['refreshToken'] = extractedRefreshToken;
        }

        return LoginResponseModel.fromJson(dataMap);
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
}
