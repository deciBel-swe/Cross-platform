import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'core/di/app_reset_provider.dart';
import 'core/di/injection.dart';
import 'features/settings/domain/repositories/app_icon_repository.dart';

void main() async {
  // 1. Essential for any native or async initialization
  WidgetsFlutterBinding.ensureInitialized();

  var useMockServices = false;
  try {
    await dotenv.load(fileName: '.env');

    // Check if we should use mocks
    useMockServices =
        (dotenv.env['USE_MOCK_SERVICES'] ?? 'false').toLowerCase() == 'true';
  } catch (_) {
    useMockServices = false;
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

  if (Platform.isAndroid || Platform.isIOS) {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.decibel.decibel.audio',
      androidNotificationChannelName: 'Decibel Playback',
      androidNotificationOngoing: true,
    );

    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        await Permission.notification.request();
      }
    }
  }

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
  runApp(
    ProviderScope(
      child: Consumer(
        builder: (context, ref, child) {
          // Initialize environment flag once
          ref
              .read(appResetProvider.notifier)
              .setEnvironment(useMockServices: useMockServices);

          final resetKey = ref.watch(appResetProvider);
          return ProviderScope(key: resetKey, child: const DecibelApp());
        },
      ),
    ),
  );
}
