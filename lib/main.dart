import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'core/constants/stripe_constants.dart';
import 'core/di/app_reset_provider.dart';
import 'core/di/injection.dart';
import 'core/services/inactivity_reminder_service.dart';
import 'features/settings/domain/repositories/app_icon_repository.dart';

void main() async {
  // 1. Essential for any native or async initialization
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
      // Ignore wrapper exception
    }

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

  final inactivityReminderService = InactivityReminderService();
  final inactivityRemindersEnabled = Platform.isAndroid || Platform.isIOS;

  if (Platform.isAndroid || Platform.isIOS) {
    await _initializeStripeSafely();
    await inactivityReminderService.initialize();

    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.decibel.decibel.audio',
      androidNotificationChannelName: 'Decibel Playback',
      androidNotificationOngoing: true,
    );
  }

  // 5. Post-DI Logic
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    try {
      final appIconRepository = getIt<AppIconRepository>();
      final selectedIcon = await appIconRepository.getSelectedIcon();
      await appIconRepository.applyIcon(selectedIcon);
    } catch (e) {
      // Ignore wrapper exception
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
          return ProviderScope(
            key: resetKey,
            child: InactivityReminderLifecycle(
              enabled: inactivityRemindersEnabled,
              service: inactivityReminderService,
              child: const DecibelApp(),
            ),
          );
        },
      ),
    ),
  );
}

Future<void> _initializeStripeSafely() async {
  try {
    Stripe.publishableKey = StripeConstants.publishableKey;
    await Stripe.instance.applySettings().timeout(const Duration(seconds: 8));
  } catch (error) {
      // Ignore wrapper exception
    }
}

class InactivityReminderLifecycle extends StatefulWidget {
  const InactivityReminderLifecycle({
    super.key,
    required this.child,
    required this.enabled,
    required this.service,
  });

  final Widget child;
  final bool enabled;
  final InactivityReminderService service;

  @override
  State<InactivityReminderLifecycle> createState() =>
      _InactivityReminderLifecycleState();
}

class _InactivityReminderLifecycleState
    extends State<InactivityReminderLifecycle>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    if (!widget.enabled) {
      return;
    }

    WidgetsBinding.instance.addObserver(this);
    unawaited(widget.service.cancelReminder());
  }

  @override
  void dispose() {
    if (widget.enabled) {
      WidgetsBinding.instance.removeObserver(this);
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!widget.enabled) {
      return;
    }

    if (state == AppLifecycleState.resumed) {
      unawaited(widget.service.cancelReminder());
      return;
    }

    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      unawaited(widget.service.scheduleReminder());
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
