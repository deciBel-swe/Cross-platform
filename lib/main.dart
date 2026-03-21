import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/constants/mock_config.dart';
import 'core/di/injection.dart';
import 'features/settings/domain/repositories/app_icon_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dependency injection
  await configureDependencies(
    environment: MockConfig.useMockData ? 'mock' : 'prod',
  );

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    try {
      final appIconRepository = getIt<AppIconRepository>();
      final selectedIcon = await appIconRepository.getSelectedIcon();
      await appIconRepository.applyIcon(selectedIcon);
    } catch (_) {}
  }

  runApp(const ProviderScope(child: DecibelApp()));
}
