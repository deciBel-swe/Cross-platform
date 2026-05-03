import 'dart:async';
import 'package:decibel/features/auth/domain/entities/auth_state.dart';
import 'package:decibel/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:decibel/features/auth/presentation/providers/auth_provider.dart';
import 'package:decibel/features/engagement/domain/entities/paginated_engagers.dart';
import 'package:decibel/features/engagement/domain/entities/track_engager.dart';
import 'package:decibel/features/engagement/presentation/notifiers/follow_notifier.dart';
import 'package:decibel/features/engagement/presentation/notifiers/track_engagers_notifier.dart';
import 'package:decibel/features/engagement/presentation/providers/follow_state_provider.dart';
import 'package:decibel/features/engagement/presentation/widgets/track_engagers_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTrackEngagersNotifier extends FamilyAsyncNotifier<PaginatedEngagers, EngagerParams>
    with Mock
    implements TrackEngagersNotifier {
  MockTrackEngagersNotifier({this.data, this.completer});
  final PaginatedEngagers? data;
  final Completer<PaginatedEngagers>? completer;

  @override
  Future<PaginatedEngagers> build(EngagerParams arg) async {
    if (completer != null) return completer!.future;
    return data ?? const PaginatedEngagers(
      content: [],
      pageNumber: 0,
      pageSize: 10,
      totalElements: 0,
      totalPages: 0,
      isLast: true,
    );
  }

  @override
  Future<void> loadMore() async {}
}

class MockFollowNotifier extends FamilyAsyncNotifier<bool, int>
    with Mock
    implements FollowNotifier {
  @override
  Future<bool> build(int arg) async => false;
  
  @override
  void setInitialState(bool value) {}
}

class MockAuthNotifier extends AsyncNotifier<AuthState>
    with Mock
    implements AuthNotifier {
  MockAuthNotifier({this.data});
  final AuthState? data;

  @override
  FutureOr<AuthState> build() => data ?? const AuthUnauthenticated();
}

void main() {
  const trackId = 1;
  const type = EngagerType.likers;
  late ScrollController scrollController;

  setUp(() {
    scrollController = ScrollController();
    registerFallbackValue(const AsyncLoading<PaginatedEngagers>());
  });

  tearDown(() {
    scrollController.dispose();
  });

  group('TrackEngagersBottomSheet', () {
    testWidgets('shows loading state initially', (tester) async {
      final completer = Completer<PaginatedEngagers>();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trackEngagersProvider.overrideWith(() => MockTrackEngagersNotifier(completer: completer)),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: TrackEngagersBottomSheet(
                trackId: trackId,
                type: type,
                scrollController: scrollController,
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty state when no engagers', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trackEngagersProvider.overrideWith(() => MockTrackEngagersNotifier(data: const PaginatedEngagers(
              content: [],
              pageNumber: 0,
              pageSize: 10,
              totalElements: 0,
              totalPages: 0,
              isLast: true,
            ))),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: TrackEngagersBottomSheet(
                trackId: trackId,
                type: type,
                scrollController: scrollController,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('No likes yet'), findsOneWidget);
    });

    testWidgets('renders list of engagers', (tester) async {
      final engagers = [
        const TrackEngager(id: 101, username: 'user1', tier: 'FREE', isFollowing: false),
        const TrackEngager(id: 102, username: 'user2', displayName: 'User Two', tier: 'PRO', isFollowing: true),
      ];
      
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trackEngagersProvider.overrideWith(() => MockTrackEngagersNotifier(data: PaginatedEngagers(
              content: engagers,
              pageNumber: 0,
              pageSize: 10,
              totalElements: 2,
              totalPages: 1,
              isLast: true,
            ))),
            authStateProvider.overrideWith(() => MockAuthNotifier(data: const AuthUnauthenticated())),
            followStateProvider.overrideWith(() => MockFollowNotifier()),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: TrackEngagersBottomSheet(
                trackId: trackId,
                type: type,
                scrollController: scrollController,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      expect(find.text('user1'), findsOneWidget);
      expect(find.text('User Two'), findsOneWidget);
    });
  });
}
