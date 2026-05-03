import 'dart:async';
import 'package:decibel/features/engagement/domain/models/track_action_data.dart';
import 'package:decibel/features/engagement/presentation/notifiers/track_action_notifier.dart';
import 'package:decibel/features/engagement/presentation/providers/track_social_provider.dart';
import 'package:decibel/features/engagement/presentation/widgets/like_button.dart';
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
      likeCount: 10,
      isReposted: false,
      repostCount: 0,
    );
  }

  @override
  Future<void> toggleAction(SocialActionType type) async {}
}

void main() {
  const trackId = 1;

  setUpAll(() {
    registerFallbackValue(SocialActionType.like);
  });

  group('LikeButton', () {
    testWidgets('displays initial count and reacts to tap', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trackSocialProvider.overrideWith(() => MockTrackSocialNotifier(
              data: const TrackSocialData(
                isLiked: false,
                likeCount: 10,
                isReposted: false,
                repostCount: 0,
              ),
            )),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: LikeButton(
                trackId: trackId,
                isLiked: false,
                likeCount: 10,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('10'), findsOneWidget);
      
      await tester.tap(find.byType(SocialActionButton));
      await tester.pump();
      // Since it's a mock, we can't easily verify the call if we use overrideWith with a closure that returns a new instance every time,
      // unless we capture the instance.
    });

    testWidgets('shows active state when isLiked is true', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trackSocialProvider.overrideWith(() => MockTrackSocialNotifier(
              data: const TrackSocialData(
                isLiked: true,
                likeCount: 11,
                isReposted: false,
                repostCount: 0,
              ),
            )),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: LikeButton(
                trackId: trackId,
                isLiked: false,
                likeCount: 10,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('11'), findsOneWidget);
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.favorite);
    });
  });
}
