import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart' as g_sign_in;
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_mock_fixtures.dart';
import '../models/login_response_model.dart';
import '../utils/auth_success_page.dart';

/// Mock implementation of [IAuthRepository] for testing and development.
@Environment('mock')
@LazySingleton(as: IAuthRepository)
class MockAuthRepository implements IAuthRepository {
  @override
  Future<Either<Failure, AuthUser>> loginWithGoogle() async {
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

      if (kDebugMode) {
        debugPrint('=== GOOGLE LOGIN SUCCESS ===');
        debugPrint('Email: ${account.email}');
        debugPrint('Display Name: ${account.displayName}');
        debugPrint('Photo URL: ${account.photoUrl}');
        debugPrint('Google ID: ${account.id}');
        debugPrint('============================');
      }

      await Future<void>.delayed(AuthMockFixtures.delay);
      const mockResponse = AuthMockFixtures.mockLoginResponse;
      final LoginResponseModel model = LoginResponseModel.fromJson(
        mockResponse,
      );

      return Right(model.user.toDomain());
    } else {
      const String clientId = ApiConstants.googleDesktopClientId;
      const String redirectUri = ApiConstants.googleDesktopRedirectUri;

      final Uri authUrl = Uri.parse(
        '${ApiConstants.googleAuthUrl}'
        '?client_id=$clientId'
        '&redirect_uri=$redirectUri'
        '&response_type=code'
        '&scope=email%20profile',
      );

      final Completer<Either<Failure, AuthUser>> completer =
          Completer<Either<Failure, AuthUser>>();

      void completeSuccess() {
        Future<void>.delayed(AuthMockFixtures.delay, () {
          const mockResponse = AuthMockFixtures.mockLoginResponse;
          final LoginResponseModel model = LoginResponseModel.fromJson(
            mockResponse,
          );

          if (!completer.isCompleted) {
            completer.complete(Right(model.user.toDomain()));
          }
        });
      }

      HttpServer? localServer;
      try {
        localServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 3000);
        localServer.listen((HttpRequest request) async {
          final Uri uri = request.uri;
          if (uri.path == '/login/oauth2/code/google' || uri.path == '/') {
            final String? authCode = uri.queryParameters['code'];

            if (authCode != null) {
              debugPrint('=== DESKTOP GOOGLE LOGIN SUCCESS ===');
              debugPrint('Authorization Code Received: $authCode');
              debugPrint('====================================');
            }
          }

          final String html = await buildAuthSuccessHtml();

          request.response
            ..statusCode = 200
            ..headers.contentType = ContentType.html
            ..write(html);

          await request.response.close();
          await localServer?.close(force: true);
          completeSuccess();
        });
      } catch (_) {
        // Ignore port binding errors if testing rapidly.
      }

      try {
        await launchUrl(authUrl, mode: LaunchMode.externalApplication);
      } catch (_) {
        await localServer?.close(force: true);
      }

      return completer.future;
    }
  }

  @override
  Future<Either<Failure, AuthUser?>> getCurrentUser() async {
    const mockResponse = AuthMockFixtures.mockLoginResponse;
    final LoginResponseModel model = LoginResponseModel.fromJson(mockResponse);

    return Right(model.user.toDomain());
  }

  @override
  Future<Either<Failure, Unit>> forgotPassword(String email) async {
    await Future<void>.delayed(AuthMockFixtures.delay);

    if (email.toLowerCase().contains('error')) {
      return const Left(
        AuthFailure('Unable to send reset link right now. Please try again.'),
      );
    }

    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> resendVerification(String email) async {
    await Future<void>.delayed(AuthMockFixtures.delay);

    if (email.toLowerCase().contains('error')) {
      return const Left(
        AuthFailure(
          'Unable to resend verification email right now. Please try again.',
        ),
      );
    }

    return const Right(unit);
  }
}
