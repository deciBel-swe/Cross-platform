import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart' as g_sign_in;
import 'package:injectable/injectable.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../models/login_response_model.dart';
import '../datasources/auth_mock_fixtures.dart';

/// Mock implementation of [IAuthRepository] for testing and development.
@Environment('mock')
@LazySingleton(as: IAuthRepository)
class MockAuthRepository implements IAuthRepository {
  @override
  Future<AuthUser> loginWithGoogle() async {
    // Launch the REAL Google Auth URL directly to test the consent screen
    final bool isMobile =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);

    if (isMobile) {
      // --- MOBILE: Use official Google Sign In SDK (In-App Popup)
      final String clientId =
          '767709617177-l61vbedk9lanvrgirt6e0840a4kijs6u.apps.googleusercontent.com';

      await g_sign_in.GoogleSignIn.instance.initialize(
        clientId: clientId,
        serverClientId:
            '767709617177-ljng08734ds2qv9m7qcrpccpe6igu9if.apps.googleusercontent.com',
      );

      await g_sign_in.GoogleSignIn.instance.signOut();
      //this account will be removed when we switch to production
      final account = await g_sign_in.GoogleSignIn.instance.authenticate(
        scopeHint: ['email', 'profile'],
      );

      if (account != null) {
        debugPrint('=== GOOGLE LOGIN SUCCESS ===');
        debugPrint('Email: ${account.email}');
        debugPrint('Display Name: ${account.displayName}');
        debugPrint('Photo URL: ${account.photoUrl}');
        debugPrint('Google ID: ${account.id}');
        debugPrint('============================');
      }

      // We don't actually need the code for mock, we just wait for delay
      await Future.delayed(AuthMockFixtures.delay);
      final mockResponse = AuthMockFixtures.mockLoginResponse;
      final model = LoginResponseModel.fromJson(mockResponse);

      return model.user.toDomain();
    } else {
      // --- DESKTOP: Use local HTTP server loopback
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

      final completer = Completer<AuthUser>();

      // Prepare the success response
      void completeSuccess() {
        Future.delayed(AuthMockFixtures.delay, () {
          final mockResponse = AuthMockFixtures.mockLoginResponse;
          final model = LoginResponseModel.fromJson(mockResponse);
          if (!completer.isCompleted) {
            completer.complete(model.user.toDomain());
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

          request.response
            ..statusCode = 200
            ..headers.contentType = ContentType.html
            ..write(
              '<html><body><h2>Mock Authentication complete! You can close this tab and return to Decibel.</h2></body></html>',
            );
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
  Future<AuthUser?> getCurrentUser() async {
    // Simulate reading from local storage without delay
    // this will be tied to SecureStorageService.
    final mockResponse = AuthMockFixtures.mockLoginResponse;
    final model = LoginResponseModel.fromJson(mockResponse);

    return model.user.toDomain();
  }
}
