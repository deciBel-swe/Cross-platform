import 'package:decibel/features/settings/presentation/providers/blocked_users_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../settings_test_helpers.dart';

void main() {
  group('BlockedUsersListNotifier', () {
    test('loadInitial stores the first blocked users page', () async {
      final repository = FakeBlockedUsersRepository(
        pages: {
          0: blockedUsersPage([blockedUser(id: 1, username: 'one')]),
        },
      );
      final container = ProviderContainer(
        overrides: [
          blockedUsersRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(blockedUsersListProvider.notifier).loadInitial();

      final state = container.read(blockedUsersListProvider);
      expect(state.users.single.username, 'one');
      expect(state.isLoading, isFalse);
      expect(state.hasError, isFalse);
    });

    test(
      'loadMore appends the next page while preserving existing users',
      () async {
        final repository = FakeBlockedUsersRepository(
          pages: {
            0: blockedUsersPage([
              blockedUser(id: 1, username: 'one'),
            ], isLast: false),
            1: blockedUsersPage([
              blockedUser(id: 2, username: 'two'),
            ], pageNumber: 1),
          },
        );
        final container = ProviderContainer(
          overrides: [
            blockedUsersRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        await container.read(blockedUsersListProvider.notifier).loadInitial();
        await container.read(blockedUsersListProvider.notifier).loadMore();

        expect(
          container.read(blockedUsersListProvider).users.map((user) => user.id),
          [1, 2],
        );
      },
    );

    test('unblockUser removes a user and reports success', () async {
      final repository = FakeBlockedUsersRepository(
        pages: {
          0: blockedUsersPage([
            blockedUser(id: 1, username: 'one'),
            blockedUser(id: 2, username: 'two'),
          ]),
        },
      );
      final container = ProviderContainer(
        overrides: [
          blockedUsersRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(blockedUsersListProvider.notifier).loadInitial();
      final result = await container
          .read(blockedUsersListProvider.notifier)
          .unblockUser(userId: 1);

      expect(result, isTrue);
      expect(repository.unblockedIds, [1]);
      expect(
        container.read(blockedUsersListProvider).users.map((user) => user.id),
        [2],
      );
    });

    test('loadInitial records an error when the repository fails', () async {
      final repository = FakeBlockedUsersRepository()
        ..loadError = Exception('network');
      final container = ProviderContainer(
        overrides: [
          blockedUsersRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(blockedUsersListProvider.notifier).loadInitial();

      final state = container.read(blockedUsersListProvider);
      expect(state.hasError, isTrue);
      expect(state.errorMessage, 'Failed to load blocked users.');
    });
  });
}
