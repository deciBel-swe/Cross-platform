import 'package:decibel/features/settings/presentation/providers/blocked_users_provider.dart';
import 'package:decibel/features/settings/presentation/providers/messaging_providers.dart';
import 'package:decibel/features/settings/presentation/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../settings_test_helpers.dart';

void main() {
  testWidgets('ChatScreen renders messages and sends text', (tester) async {
    final messagingRepository = FakeMessagingRepository()
      ..messagePages[0] = paginated([
        message(senderId: 2, content: 'hello from friend'),
      ]);

    await tester.pumpWidget(
      settingsTestApp(
        const ChatScreen(conversationId: '1_2', otherUserName: 'Friend'),
        overrides: [
          messagingRepositoryProvider.overrideWithValue(messagingRepository),
          profileRepositoryProvider.overrideWithValue(FakeProfileRepository()),
          blockedUsersRepositoryProvider.overrideWithValue(
            FakeBlockedUsersRepository(pages: {0: blockedUsersPage(const [])}),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('hello from friend'), findsOneWidget);

    await tester.enterText(find.byType(EditableText), 'reply');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    expect(messagingRepository.sentContents, ['reply']);
  });

  testWidgets('ChatScreen opens and cancels the block confirmation dialog', (
    tester,
  ) async {
    final messagingRepository = FakeMessagingRepository()
      ..messagePages[0] = paginated([message(senderId: 2)]);

    await tester.pumpWidget(
      settingsTestApp(
        const ChatScreen(conversationId: '1_2', otherUserName: 'Friend'),
        overrides: [
          messagingRepositoryProvider.overrideWithValue(messagingRepository),
          profileRepositoryProvider.overrideWithValue(FakeProfileRepository()),
          blockedUsersRepositoryProvider.overrideWithValue(
            FakeBlockedUsersRepository(pages: {0: blockedUsersPage(const [])}),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Block user'));
    await tester.pumpAndSettle();

    expect(find.text('Block user?'), findsOneWidget);
    expect(find.textContaining('Friend'), findsWidgets);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Block user?'), findsNothing);
  });

  testWidgets('ChatScreen renders the desktop header at wide sizes', (
    tester,
  ) async {
    final messagingRepository = FakeMessagingRepository();

    await tester.pumpWidget(
      settingsTestApp(
        const ChatScreen(conversationId: '1_2', otherUserName: 'Friend'),
        size: const Size(1000, 900),
        overrides: [
          messagingRepositoryProvider.overrideWithValue(messagingRepository),
          profileRepositoryProvider.overrideWithValue(FakeProfileRepository()),
          blockedUsersRepositoryProvider.overrideWithValue(
            FakeBlockedUsersRepository(pages: {0: blockedUsersPage(const [])}),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Friend'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });
}
