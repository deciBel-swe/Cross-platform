import 'package:decibel/features/settings/presentation/providers/messaging_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../settings_test_helpers.dart';

void main() {
  group('ChatScreenNotifier', () {
    test('build resolves the other participant from the conversation id', () {
      final repository = FakeMessagingRepository();
      final container = ProviderContainer(
        overrides: [messagingRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      final state = container.read(chatScreenControllerProvider('1_2'));

      expect(state.currentUserId, 1);
      expect(state.otherUserId, 2);
      expect(state.conversationId, '1_2');
    });

    test(
      'sendTextMessage trims text and sends it to the resolved recipient',
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
            .read(chatScreenControllerProvider('1_2').notifier)
            .sendTextMessage('  hello  ');

        expect(repository.sentContents, ['hello']);
      },
    );

    test(
      'isMessageFromMe compares the message sender with the current user',
      () {
        final repository = FakeMessagingRepository();
        final container = ProviderContainer(
          overrides: [
            messagingRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        final notifier = container.read(
          chatScreenControllerProvider('1_2').notifier,
        );

        expect(notifier.isMessageFromMe(message(senderId: 1)), isTrue);
        expect(notifier.isMessageFromMe(message(senderId: 2)), isFalse);
      },
    );
  });
}
