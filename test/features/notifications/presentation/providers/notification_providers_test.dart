import 'package:decibel/core/di/injection.dart';
import 'package:decibel/features/notifications/domain/repositories/notification_repository.dart';
import 'package:decibel/features/notifications/presentation/providers/notification_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../notification_test_helpers.dart';

void main() {
  tearDown(() async {
    await getIt.reset();
  });

  test('notificationRepositoryProvider reads the repository from GetIt', () {
    final repository = FakeNotificationRepository();
    getIt.registerSingleton<INotificationRepository>(repository);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(notificationRepositoryProvider), same(repository));
  });
}
