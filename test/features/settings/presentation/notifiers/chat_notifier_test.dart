import 'package:decibel/features/settings/domain/entities/message_resource_preview.dart';
import 'package:decibel/features/settings/presentation/providers/messaging_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../settings_test_helpers.dart';

void main() {
  group('ChatNotifier', () {
    test('build loads the first message page for a conversation', () async {
      final repository = FakeMessagingRepository();
      final container = ProviderContainer(
        overrides: [messagingRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      final state = await container.read(chatProvider('1_2').future);

      expect(state.messages.single.senderId, 2);
      expect(repository.requestedMessagePages, [0]);
    });

    test('loadMoreHistory appends older messages', () async {
      final repository = FakeMessagingRepository()
        ..messagePages[0] = paginated([
          message(id: 'm1', content: 'newer'),
        ], isLast: false)
        ..messagePages[1] = paginated([
          message(id: 'm2', content: 'older'),
        ], pageNumber: 1);
      final container = ProviderContainer(
        overrides: [messagingRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(chatProvider('1_2').future);
      await container.read(chatProvider('1_2').notifier).loadMoreHistory();

      expect(
        container
            .read(chatProvider('1_2'))
            .value
            ?.messages
            .map((item) => item.id),
        ['m1', 'm2'],
      );
    });

    test(
      'sendMessage forwards trimmed content to the repository caller',
      () async {
        final repository = FakeMessagingRepository()
          ..sentMessage = message(id: 'sent', content: 'hello');
        final container = ProviderContainer(
          overrides: [
            messagingRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        await container.read(chatProvider('1_2').future);
        await container
            .read(chatProvider('1_2').notifier)
            .sendMessage('hello', recipientId: 2);

        expect(repository.sentContents, ['hello']);
        expect(
          container.read(chatProvider('1_2')).value?.messages.first.id,
          'sent',
        );
      },
    );

    test(
      'sendResourceMessage builds a parseable shared resource marker',
      () async {
        final repository = FakeMessagingRepository();
        final container = ProviderContainer(
          overrides: [
            messagingRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        await container.read(chatProvider('1_2').future);
        await container
            .read(chatProvider('1_2').notifier)
            .sendResourceMessage(
              resourceType: 'TRACK',
              resourceId: 99,
              title: 'Shared Track',
              subtitle: 'Artist',
              recipientId: 2,
            );

        final parsed = parseMessageResourceContent(
          repository.sentContents.single,
        );
        expect(parsed.resourceType, 'TRACK');
        expect(parsed.resourceId, 99);
        expect(parsed.displayTitle, 'Shared Track');
      },
    );
  });
}
