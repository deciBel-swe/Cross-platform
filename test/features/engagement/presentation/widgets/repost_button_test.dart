import 'dart:async';
import 'package:decibel/features/engagement/domain/models/track_action_data.dart';
import 'package:decibel/features/engagement/presentation/notifiers/track_action_notifier.dart';
import 'package:decibel/features/engagement/presentation/providers/track_social_provider.dart';
import 'package:decibel/features/engagement/presentation/widgets/repost_button.dart';
import 'package:decibel/features/engagement/presentation/widgets/social_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTrackSocialNotifier extends FamilyAsyncNotifier<TrackSocialData, int>
    with Mock
    implements TrackSocialNotifier {
  MockTrackSocialNotifier({this.data});
  final TrackSocialData? data;

  @override
  FutureOr<TrackSocialData> build(int arg) {
    return data ?? const TrackSocialData(
      isLiked: false,
      likeCount: 0,
      isReposted: false,
      repostCount: 5,
    );
  }

  @override
  Future<void> toggleAction(SocialActionType type) async {}
}

void main() {
  const trackId = 1;

  setUpAll(() {
    registerFallbackValue(SocialActionType.repost);
  });

  group('RepostButton', () {
    testWidgets('displays initial count and reacts to tap', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trackSocialProvider.overrideWith(() => MockTrackSocialNotifier(
              data: const TrackSocialData(
                isLiked: false,
                likeCount: 0,
                isReposted: false,
                repostCount: 5,
              ),
            )),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: RepostButton(
                trackId: trackId,
                isReposted: false,
                repostCount: 5,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('5'), findsOneWidget);
      
      await tester.tap(find.byType(SocialActionButton));
      await tester.pump();
    });

    testWidgets('shows active state when isReposted is true', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trackSocialProvider.overrideWith(() => MockTrackSocialNotifier(
              data: const TrackSocialData(
                isLiked: false,
                likeCount: 0,
                isReposted: true,
                repostCount: 6,
              ),
            )),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: RepostButton(
                trackId: trackId,
                isReposted: false,
                repostCount: 5,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('6'), findsOneWidget);
    });
  });
}
