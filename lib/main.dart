import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'core/constants/api_constants.dart';
import 'core/di/injection.dart';
import 'features/settings/domain/repositories/app_icon_repository.dart';

void main() async {
  // 1. Essential for any native or async initialization
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Load and Validate Environment
  var useMockServices = false;
  try {
    await dotenv.load(fileName: '.env');

    // Check if we should use mocks
    useMockServices =
        (dotenv.env['USE_MOCK_SERVICES'] ?? 'false').toLowerCase() == 'true';

    // Ensure all required keys exist before we let GetIt start
    ApiConstants.validate();
    debugPrint("✅ Environment loaded and validated.");
  } catch (e) {
    debugPrint("⚠️ Environment initialization failed: $e");
    // If it's not a mock build and env failed, the app will crash later anyway.
    // You might want to set useMockServices = true here for testing safety.
    if (useMockServices == false) {
      debugPrint("🚨 Warning: Proceeding without a valid .env file.");
    }
  }

  // 3. Configure Desktop Windows (Non-blocking)
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();
    const minSize = Size(1024, 600);
    await windowManager.setMinimumSize(minSize);
  }

  // 4. Dependency Injection (CRITICAL: Added 'await')
  // Many injectable setups return Future<GetIt>. If yours does, you MUST await it.
  configureDependencies(useMockServices: useMockServices);

  // 5. Post-DI Logic
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    try {
      final appIconRepository = getIt<AppIconRepository>();
      final selectedIcon = await appIconRepository.getSelectedIcon();
      await appIconRepository.applyIcon(selectedIcon);
    } catch (e) {
      debugPrint("Failed to apply app icon: $e");
    }
  }

  // 6. Start UI
  runApp(const ProviderScope(child: DecibelApp()));
}
