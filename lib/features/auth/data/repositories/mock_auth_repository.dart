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
    // Launch the REAL Google Auth URL directly to test the consent screen
    final bool isMobile =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);

    if (isMobile) {
      // --- MOBILE: Use official Google Sign In SDK (In-App Popup)
      const String clientId = ApiConstants.googleMobileClientId;

      await g_sign_in.GoogleSignIn.instance.initialize(
        clientId: clientId,
        serverClientId: ApiConstants.googleDesktopClientId,
      );

      await g_sign_in.GoogleSignIn.instance.signOut();
      //this account will be removed when we switch to production
      final account = await g_sign_in.GoogleSignIn.instance.authenticate(
        scopeHint: ['email', 'profile'],
      );

      // wow so this is a flag to run only in debug mode very USEFUL
      if (kDebugMode) {
        debugPrint('=== GOOGLE LOGIN SUCCESS ===');
        debugPrint('Email: ${account.email}');
        debugPrint('Display Name: ${account.displayName}');
        debugPrint('Photo URL: ${account.photoUrl}');
        debugPrint('Google ID: ${account.id}');
        debugPrint('============================');
      }

      // We don't actually need the code for mock, we just wait for delay
      await Future<void>.delayed(AuthMockFixtures.delay);
      const mockResponse = AuthMockFixtures.mockLoginResponse;
      final model = LoginResponseModel.fromJson(mockResponse);

      return Right(model.user.toDomain());
    } else {
      // --- DESKTOP: Use local HTTP server loopback
      const String clientId = ApiConstants.googleDesktopClientId;
      const String redirectUri = ApiConstants.googleDesktopRedirectUri;

      final authUrl = Uri.parse(
        '${ApiConstants.googleAuthUrl}'
        '?client_id=$clientId'
        '&redirect_uri=$redirectUri'
        '&response_type=code'
        '&scope=email%20profile',
      );

      final completer = Completer<Either<Failure, AuthUser>>();

      // Prepare the success response
      void completeSuccess() {
        Future<void>.delayed(AuthMockFixtures.delay, () {
          const mockResponse = AuthMockFixtures.mockLoginResponse;
          final model = LoginResponseModel.fromJson(mockResponse);
          if (!completer.isCompleted) {
            completer.complete(Right(model.user.toDomain()));
          }
        });
      }

      HttpServer? localServer;
      try {
        localServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 3000);
        localServer.listen((HttpRequest request) async {
          final uri = request.uri;
          if (uri.path == '/login/oauth2/code/google' || uri.path == '/') {
            final authCode = uri.queryParameters['code'];

            if (authCode != null) {
              debugPrint('=== DESKTOP GOOGLE LOGIN SUCCESS ===');
              debugPrint('Authorization Code Received: $authCode');
              debugPrint('====================================');
            }
          }

          final html = await buildAuthSuccessHtml();

          request.response
            ..statusCode = 200
            ..headers.contentType = ContentType.html
            ..write(html);
          await request.response.close();
          await localServer?.close(force: true);
          completeSuccess();
        });
      } catch (_) {
        // Ignore port binding errors if testing rapidly
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
    // Simulate reading from local storage without delay
    // this will be tied to SecureStorageService.
    const mockResponse = AuthMockFixtures.mockLoginResponse;
    final model = LoginResponseModel.fromJson(mockResponse);

    return Right(model.user.toDomain());
  }
}
