import 'package:decibel/features/settings/presentation/providers/messaging_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../settings_test_helpers.dart';

void main() {
  group('ConversationsNotifier', () {
    test('build loads the first conversations page', () async {
      final repository = FakeMessagingRepository()
        ..conversationsPage = paginated([
          conversation(id: '1_2', lastMessage: 'hi'),
        ]);
      final container = ProviderContainer(
        overrides: [messagingRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      final state = await container.read(conversationsProvider.future);

      expect(state.conversations.single.lastMessage, 'hi');
      expect(repository.requestedConversationPages, [0]);
    });

    test('refresh reloads page zero', () async {
      final repository = FakeMessagingRepository();
      final container = ProviderContainer(
        overrides: [messagingRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(conversationsProvider.future);
      await container.read(conversationsProvider.notifier).refresh();

      expect(repository.requestedConversationPages, [0, 0]);
    });

    test(
      'loadMore appends conversations that are not already present',
      () async {
        final repository = FakeMessagingRepository()
          ..conversationsPage = paginated([
            conversation(id: '1_2'),
          ], isLast: false);
        final container = ProviderContainer(
          overrides: [
            messagingRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        await container.read(conversationsProvider.future);
        repository.conversationsPage = paginated([
          conversation(id: '1_2'),
          conversation(id: '1_3'),
        ], pageNumber: 1);

        await container.read(conversationsProvider.notifier).loadMore();

        expect(
          container
              .read(conversationsProvider)
              .value
              ?.conversations
              .map((item) => item.id),
          ['1_2', '1_3'],
        );
      },
    );

    test(
      'markConversationRead and incrementUnreadCount update local counters',
      () async {
        final repository = FakeMessagingRepository()
          ..conversationsPage = paginated([
            conversation(id: '1_2', unreadCount: 3),
          ]);
        final container = ProviderContainer(
          overrides: [
            messagingRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        await container.read(conversationsProvider.future);
        container
            .read(conversationsProvider.notifier)
            .markConversationRead('1_2');
        expect(
          container
              .read(conversationsProvider)
              .value
              ?.conversations
              .single
              .unreadCount,
          0,
        );

        container
            .read(conversationsProvider.notifier)
            .incrementUnreadCount('1_2');
        expect(
          container
              .read(conversationsProvider)
              .value
              ?.conversations
              .single
              .unreadCount,
          1,
        );
      },
    );
  });
}
