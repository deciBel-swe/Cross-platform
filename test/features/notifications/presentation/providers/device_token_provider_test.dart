import 'dart:async';

import 'package:decibel/core/network/firebase_messaging_service.dart.dart';
import 'package:decibel/features/notifications/domain/repositories/notification_repository.dart';
import 'package:decibel/features/notifications/presentation/providers/device_token_provider.dart';
import 'package:decibel/features/notifications/presentation/providers/notification_providers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseMessagingService extends Mock
    implements FirebaseMessagingService {}

class MockNotificationRepository extends Mock
    implements INotificationRepository {}

void main() {
  late MockFirebaseMessagingService mockFirebaseMessagingService;
  late MockNotificationRepository mockNotificationRepository;
  late ProviderContainer container;
  late StreamController<String> tokenRefreshController;

  setUp(() {
    mockFirebaseMessagingService = MockFirebaseMessagingService();
    mockNotificationRepository = MockNotificationRepository();
    tokenRefreshController = StreamController<String>.broadcast();

    when(
      () => mockFirebaseMessagingService.requestPermission(),
    ).thenAnswer((_) async => true);
    when(
      () => mockFirebaseMessagingService.getDeviceToken(),
    ).thenAnswer((_) async => 'initial-token');
    when(
      () => mockFirebaseMessagingService.onTokenRefresh,
    ).thenAnswer((_) => tokenRefreshController.stream);
    when(
      () => mockFirebaseMessagingService.onForegroundMessage,
    ).thenAnswer((_) => const Stream<RemoteMessage>.empty());
    when(
      () => mockNotificationRepository.registerDeviceToken(any()),
    ).thenAnswer((_) async => null);

    container = ProviderContainer(
      overrides: [
        firebaseMessagingServiceProvider.overrideWithValue(
          mockFirebaseMessagingService,
        ),
        notificationRepositoryProvider.overrideWithValue(
          mockNotificationRepository,
        ),
      ],
    );
  });

  tearDown(() async {
    await tokenRefreshController.close();
    container.dispose();
  });

  test(
    'syncDeviceTokenProvider registers the initial token and refresh tokens through the notifications repository',
    () async {
      final subscription = container.listen<AsyncValue<void>>(
        syncDeviceTokenProvider,
        (previous, next) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      await container.read(syncDeviceTokenProvider.future);

      verify(
        () => mockNotificationRepository.registerDeviceToken('initial-token'),
      ).called(1);

      tokenRefreshController.add('refreshed-token');
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      verify(
        () => mockNotificationRepository.registerDeviceToken('refreshed-token'),
      ).called(1);
      verifyNever(
        () => mockNotificationRepository.registerDeviceToken('duplicate-token'),
      );
    },
  );
}
