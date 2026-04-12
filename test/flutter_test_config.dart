import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel pathProviderChannel = MethodChannel(
    'plugins.flutter.io/path_provider',
  );

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(pathProviderChannel, (
        MethodCall methodCall,
      ) async {
        if (methodCall.method == 'getTemporaryDirectory' ||
            methodCall.method == 'getApplicationSupportDirectory' ||
            methodCall.method == 'getApplicationDocumentsDirectory') {
          final dir = Directory.systemTemp.createTempSync('flutter_test_path_');
          return dir.path;
        }
        return null;
      });

  dotenv.testLoad(
    fileInput:
        'API_BASE_URL=http://localhost:8082/api\n'
        'GOOGLE_MOBILE_CLIENT_ID=test-mobile-client-id\n'
        'GOOGLE_DESKTOP_CLIENT_ID=test-desktop-client-id\n'
        'USE_MOCK_SERVICES=true',
  );

  await testMain();
}
