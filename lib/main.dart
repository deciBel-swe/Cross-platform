import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'features/settings/domain/repositories/app_icon_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure desktop window constraints.
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();
    const minSize = Size(1024, 600);
    await windowManager.setMinimumSize(minSize);
  }

  // Dependency injection
  configureDependencies();

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    try {
      final appIconRepository = getIt<AppIconRepository>();
      final selectedIcon = await appIconRepository.getSelectedIcon();
      await appIconRepository.applyIcon(selectedIcon);
    } catch (_) {}
  }

  runApp(const ProviderScope(child: DecibelApp()));
}
