import 'dart:async';
import 'package:decibel/features/auth/domain/entities/auth_state.dart';
import 'package:decibel/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:decibel/features/auth/presentation/providers/auth_provider.dart';
import 'package:decibel/features/engagement/domain/entities/paginated_engagers.dart';
import 'package:decibel/features/engagement/domain/entities/track_engager.dart';
import 'package:decibel/features/engagement/presentation/notifiers/follow_notifier.dart';
import 'package:decibel/features/engagement/presentation/providers/follow_connections_provider.dart';
import 'package:decibel/features/engagement/presentation/providers/follow_state_provider.dart';
import 'package:decibel/features/engagement/presentation/screens/follow_connections_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFollowNotifier extends FamilyAsyncNotifier<bool, int>
    with Mock
    implements FollowNotifier {
  @override
  Future<bool> build(int arg) async => false;
}

class MockAuthNotifier extends AsyncNotifier<AuthState> with Mock implements AuthNotifier {
  final AsyncValue<AuthState> initialState;
  MockAuthNotifier(this.initialState);

  @override
  FutureOr<AuthState> build() => initialState.value!;
}

void main() {
  const userId = 123;
  const otherUserId = 456;

  final testUser = TrackEngager(
    id: otherUserId,
    username: 'otheruser',
    displayName: 'Other User',
    tier: 'FREE',
    isFollowing: false,
  );

  final emptyPaginated = PaginatedEngagers(
    content: [],
    pageNumber: 0,
    pageSize: 20,
    totalElements: 0,
    totalPages: 0,
    isLast: true,
  );

  final singleUserPaginated = PaginatedEngagers(
    content: [testUser],
    pageNumber: 0,
    pageSize: 20,
    totalElements: 1,
    totalPages: 1,
    isLast: true,
  );

  testWidgets('FollowConnectionsScreen displays followers and suggested users', (tester) async {
    final mockFollowNotifier = MockFollowNotifier();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith(() => MockAuthNotifier(const AsyncData(AuthUnauthenticated()))),
          followConnectionsProvider((userId: userId, type: FollowConnectionsType.followers))
              .overrideWith((ref) => Future.value(singleUserPaginated)),
          suggestedUsersProvider.overrideWith((ref) => Future.value(singleUserPaginated)),
          followStateProvider.overrideWith(() => mockFollowNotifier),
        ],
        child: const MaterialApp(
          home: FollowConnectionsScreen(
            userId: userId,
            type: FollowConnectionsType.followers,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Followers'), findsAtLeastNWidgets(1));
    expect(find.text('Suggested'), findsAtLeastNWidgets(1));
    expect(find.text('Other User'), findsNWidgets(2)); // One in followers, one in suggested
  });

  testWidgets('FollowConnectionsScreen shows loading state', (tester) async {
     await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith(() => MockAuthNotifier(const AsyncData(AuthUnauthenticated()))),
          followConnectionsProvider((userId: userId, type: FollowConnectionsType.followers))
              .overrideWith((ref) => Completer<PaginatedEngagers>().future),
          suggestedUsersProvider.overrideWith((ref) => Completer<PaginatedEngagers>().future),
        ],
        child: const MaterialApp(
          home: FollowConnectionsScreen(
            userId: userId,
            type: FollowConnectionsType.followers,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
  });

  testWidgets('FollowConnectionsScreen shows empty state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith(() => MockAuthNotifier(const AsyncData(AuthUnauthenticated()))),
          followConnectionsProvider((userId: userId, type: FollowConnectionsType.followers))
              .overrideWith((ref) => Future.value(emptyPaginated)),
          suggestedUsersProvider.overrideWith((ref) => Future.value(emptyPaginated)),
        ],
        child: const MaterialApp(
          home: FollowConnectionsScreen(
            userId: userId,
            type: FollowConnectionsType.followers,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No followers yet'), findsOneWidget);
    expect(find.text('No suggestions right now'), findsOneWidget);
  });
}
