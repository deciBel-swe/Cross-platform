import 'package:decibel/features/settings/domain/entities/message_resource_preview.dart';
import 'package:decibel/features/settings/presentation/providers/messaging_providers.dart';
import 'package:decibel/features/settings/presentation/widgets/chat_input_bar.dart';
import 'package:decibel/features/settings/presentation/widgets/conversation_tile.dart';
import 'package:decibel/features/settings/presentation/widgets/message_bubble.dart';
import 'package:decibel/features/settings/presentation/widgets/message_bubble_content.dart';
import 'package:decibel/features/settings/presentation/widgets/message_bubble_resource_artwork.dart';
import 'package:decibel/features/settings/presentation/widgets/message_bubble_resource_preview_card.dart';
import 'package:decibel/features/settings/presentation/widgets/message_bubble_sender_avatar.dart';
import 'package:decibel/features/settings/presentation/widgets/message_bubble_timestamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../settings_test_helpers.dart';

void main() {
  Widget app(
    Widget child, {
    FakeMessagingRepository? messagingRepository,
    FakeProfileRepository? profileRepository,
  }) {
    return ProviderScope(
      overrides: [
        messagingRepositoryProvider.overrideWithValue(
          messagingRepository ?? FakeMessagingRepository(),
        ),
        profileRepositoryProvider.overrideWithValue(
          profileRepository ?? FakeProfileRepository(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(body: child),
      ),
    );
  }

  group('message widgets', () {
    testWidgets('ChatInputBar sends trimmed text and exposes attach action', (
      tester,
    ) async {
      String? sent;
      var attached = false;

      await tester.pumpWidget(
        app(
          ChatInputBar(
            onSend: (text) => sent = text,
            onAttach: () => attached = true,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      expect(attached, isTrue);

      await tester.enterText(find.byType(TextField), '  hello  ');
      await tester.pump();
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      expect(sent, 'hello');
      expect(find.text('hello'), findsNothing);
    });

    testWidgets('MessageBubbleContent renders plain text', (tester) async {
      await tester.pumpWidget(
        app(
          const MessageBubbleContent(
            parsed: MessageResourcePreview(cleanText: 'plain message'),
          ),
        ),
      );

      expect(find.text('plain message'), findsOneWidget);
    });

    testWidgets('MessageBubbleContent renders text and resource preview', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          const MessageBubbleContent(
            parsed: MessageResourcePreview(
              cleanText: 'listen to this',
              resourceType: 'TRACK',
              resourceId: 7,
              title: 'Shared track',
              subtitle: 'Artist',
            ),
          ),
        ),
      );

      expect(find.text('listen to this'), findsOneWidget);
      expect(find.text('Shared track'), findsOneWidget);
      expect(find.text('Artist'), findsOneWidget);
      expect(find.text('Track'), findsOneWidget);
    });

    testWidgets('MessageBubbleResourceArtwork falls back to resource icons', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          const Row(
            children: [
              MessageBubbleResourceArtwork(imageUrl: null, isTrack: true),
              MessageBubbleResourceArtwork(imageUrl: '', isTrack: false),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.music_note), findsOneWidget);
      expect(find.byIcon(Icons.queue_music), findsOneWidget);
    });

    testWidgets('MessageBubbleTimestamp renders excluded timestamp text', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(const MessageBubbleTimestamp(timeString: '2m')),
      );

      expect(find.text('2m'), findsOneWidget);
    });

    testWidgets('MessageBubble aligns outgoing and incoming messages', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          Column(
            children: [
              MessageBubble(message: message(senderId: 1), isMe: true),
              MessageBubble(
                message: message(senderId: 2, content: 'incoming'),
                isMe: false,
                otherUserId: null,
              ),
            ],
          ),
        ),
      );

      expect(find.text('hello'), findsOneWidget);
      expect(find.text('incoming'), findsOneWidget);
      expect(find.byType(MessageBubbleSenderAvatar), findsOneWidget);
    });

    testWidgets('ConversationTile renders profile name and unread badge', (
      tester,
    ) async {
      final messagingRepository = FakeMessagingRepository();

      await tester.pumpWidget(
        app(
          ConversationTile(
            conversation: conversation(unreadCount: 4),
            currentUserId: 1,
            onTap: () {},
          ),
          messagingRepository: messagingRepository,
          profileRepository: FakeProfileRepository(
            profile: userProfile(displayName: 'Other User'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Other User'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('MessageBubbleResourcePreviewCard opens track route', (
      tester,
    ) async {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const Scaffold(
              body: MessageBubbleResourcePreviewCard(
                resource: MessageResourcePreview(
                  cleanText: '',
                  resourceType: 'TRACK',
                  resourceId: 7,
                  title: 'Shared track',
                  subtitle: 'Artist',
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/library/track-preview/:trackId',
            builder: (_, state) => Scaffold(
              body: Text('Track ${state.pathParameters['trackId']}'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.tap(find.text('Shared track'));
      await tester.pumpAndSettle();

      expect(find.text('Track 7'), findsOneWidget);
    });
  });
}
