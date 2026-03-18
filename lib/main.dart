import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/constants/mock_config.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dependency injection
  await configureDependencies(
    environment: MockConfig.useMockData ? 'mock' : 'prod',
  );

  runApp(const ProviderScope(child: DecibelApp()));
}
