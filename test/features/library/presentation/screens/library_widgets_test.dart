import 'package:decibel/features/library/presentation/widgets/comment_header.dart';
import 'package:decibel/features/library/presentation/widgets/comment_reaction_bar.dart';
import 'package:decibel/features/library/presentation/widgets/like_section.dart';
import 'package:decibel/features/library/presentation/widgets/reaction_button.dart';
import 'package:decibel/features/library/presentation/widgets/track_comment_avatar.dart';
import 'package:decibel/features/library/presentation/widgets/waveform_not_ready.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('CommentHeader', () {
    testWidgets('renders username, timestamp, and time ago', (tester) async {
      var didTapTimestamp = false;

      await tester.pumpWidget(
        buildTestWidget(
          CommentHeader(
            username: 'tarek',
            timestamp: '0:12',
            timeAgo: '2m',
            onTimestampTap: () => didTapTimestamp = true,
          ),
        ),
      );

      expect(find.text('tarek'), findsOneWidget);
      expect(find.text('at'), findsOneWidget);
      expect(find.text('0:12'), findsOneWidget);
      expect(find.text('• 2m'), findsOneWidget);

      await tester.tap(find.text('0:12'));
      expect(didTapTimestamp, isTrue);
    });
  });

  group('ReactionButton', () {
    testWidgets('renders emoji and calls onTap', (tester) async {
      var didTap = false;

      await tester.pumpWidget(
        buildTestWidget(
          ReactionButton(emoji: '🔥', onTap: () => didTap = true),
        ),
      );

      expect(find.text('🔥'), findsOneWidget);

      await tester.tap(find.text('🔥'));
      expect(didTap, isTrue);
    });
  });

  group('LikeSection', () {
    testWidgets('renders heart icon and count', (tester) async {
      await tester.pumpWidget(buildTestWidget(const LikeSection(count: '12')));

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
    });
  });

  group('TrackCommentAvatar', () {
    testWidgets('renders fallback icon when avatarUrl is null', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const TrackCommentAvatar(avatarUrl: null)),
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('renders fallback icon when avatarUrl is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(const TrackCommentAvatar(avatarUrl: '')),
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('does not render fallback icon when avatarUrl exists', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const TrackCommentAvatar(avatarUrl: 'https://example.com/avatar.png'),
        ),
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byIcon(Icons.person), findsNothing);
    });
  });

  group('WaveformNotReady', () {
    testWidgets('renders waveform not ready message', (tester) async {
      await tester.pumpWidget(buildTestWidget(const WaveformNotReady()));

      expect(find.text('Waveform is not ready yet.'), findsOneWidget);
    });
  });

  group('CommentReactionBar', () {
    testWidgets('renders timestamp when timestamp exists and input is empty', (
      tester,
    ) async {
      final controller = TextEditingController();
      final focusNode = FocusNode();

      await tester.pumpWidget(
        buildTestWidget(
          CommentReactionBar(
            controller: controller,
            focusNode: focusNode,
            timestamp: '0:15',
          ),
        ),
      );

      expect(find.text('0:15'), findsOneWidget);
      expect(find.byIcon(Icons.send_rounded), findsNothing);

      controller.dispose();
      focusNode.dispose();
    });

    testWidgets(
      'renders quick reactions when no timestamp and input is empty',
      (tester) async {
        final controller = TextEditingController();
        final focusNode = FocusNode();

        await tester.pumpWidget(
          buildTestWidget(
            CommentReactionBar(controller: controller, focusNode: focusNode),
          ),
        );

        expect(find.text('🔥'), findsOneWidget);
        expect(find.text('👏'), findsOneWidget);
        expect(find.text('🥺'), findsOneWidget);
        expect(find.byIcon(Icons.send_rounded), findsNothing);

        controller.dispose();
        focusNode.dispose();
      },
    );

    testWidgets('calls onReactionTap when quick reaction is tapped', (
      tester,
    ) async {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      String? selectedReaction;

      await tester.pumpWidget(
        buildTestWidget(
          CommentReactionBar(
            controller: controller,
            focusNode: focusNode,
            onReactionTap: (value) => selectedReaction = value,
          ),
        ),
      );

      await tester.tap(find.text('🔥'));

      expect(selectedReaction, '🔥');

      controller.dispose();
      focusNode.dispose();
    });

    testWidgets('renders send button when input has text', (tester) async {
      final controller = TextEditingController();
      final focusNode = FocusNode();

      await tester.pumpWidget(
        buildTestWidget(
          CommentReactionBar(controller: controller, focusNode: focusNode),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Nice track');
      await tester.pump();

      expect(find.byIcon(Icons.send_rounded), findsOneWidget);
      expect(find.text('🔥'), findsNothing);
      expect(find.text('👏'), findsNothing);
      expect(find.text('🥺'), findsNothing);

      controller.dispose();
      focusNode.dispose();
    });

    testWidgets('submits trimmed input when send is tapped', (tester) async {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      String? submittedText;

      await tester.pumpWidget(
        buildTestWidget(
          CommentReactionBar(
            controller: controller,
            focusNode: focusNode,
            onSendTap: (value) => submittedText = value,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Nice track');
      await tester.pump();

      await tester.tap(find.byIcon(Icons.send_rounded));

      expect(submittedText, 'Nice track');

      controller.dispose();
      focusNode.dispose();
    });
  });
}
