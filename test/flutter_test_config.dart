import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  dotenv.testLoad(
    fileInput:
        'API_BASE_URL=http://localhost:8082/api\n'
        'GOOGLE_MOBILE_CLIENT_ID=test-mobile-client-id\n'
        'GOOGLE_DESKTOP_CLIENT_ID=test-desktop-client-id\n'
        'USE_MOCK_SERVICES=true',
  );

  await testMain();
}
