import 'dart:async';
import 'package:decibel/features/engagement/presentation/notifiers/follow_notifier.dart';
import 'package:decibel/features/engagement/presentation/providers/follow_state_provider.dart';
import 'package:decibel/features/engagement/presentation/widgets/follow_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFollowNotifier extends FamilyAsyncNotifier<bool, int>
    with Mock
    implements FollowNotifier {
  final bool initialState;
  MockFollowNotifier([this.initialState = false]);

  @override
  Future<bool> build(int arg) async => initialState;
}

void main() {
  const userId = 123;

  group('FollowButton', () {
    testWidgets('shows Follow when not following', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            followStateProvider.overrideWith(() => MockFollowNotifier(false)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: FollowButton(
                userId: userId,
                isFollowedBy: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Follow'), findsOneWidget);
    });

    testWidgets('shows Following when following', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            followStateProvider.overrideWith(() => MockFollowNotifier(true)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: FollowButton(
                userId: userId,
                isFollowedBy: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Following'), findsOneWidget);
    });
  });
}
