import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure desktop window constraints.
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();
    const minSize = Size(400, 600);
    const maxSize = Size(1920, 1080);
    await windowManager.setMinimumSize(minSize);
    await windowManager.setMaximumSize(maxSize);
  }

  // Dependency injection
  configureDependencies();

  runApp(const ProviderScope(child: DecibelApp()));
}
