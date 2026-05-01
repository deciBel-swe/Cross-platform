import 'package:dartz/dartz.dart';
import 'package:decibel/core/router/route_paths.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/home/domain/entities/listening_history_page.dart';
import 'package:decibel/features/home/domain/repositories/history_repository.dart';
import 'package:decibel/features/home/presentation/providers/history_provider.dart';
import 'package:decibel/features/library/presentation/screens/library_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class FakeHistoryRepository implements HistoryRepository {
  @override
  Future<Either<Failure, ListeningHistoryPage>> getListeningHistory({
    int page = 0,
    int size = 20,
  }) async {
    return Right(
      ListeningHistoryPage(
        content: const [],
        pageNumber: page,
        pageSize: size,
        totalElements: 0,
        totalPages: 0,
        isLast: true,
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> incrementPlayCount({
    required int trackId,
  }) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, bool>> markTrackCompleted({
    required int trackId,
  }) async {
    return const Right(true);
  }
}

void main() {
  Widget buildTestWidget({GoRouter? router}) {
    final defaultRouter = GoRouter(
      initialLocation: RoutePaths.library,
      routes: [
        GoRoute(
          path: RoutePaths.library,
          builder: (context, state) => const LibraryScreen(),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        historyRepositoryProvider.overrideWithValue(FakeHistoryRepository()),
      ],
      child: MaterialApp.router(routerConfig: router ?? defaultRouter),
    );
  }

  group('LibraryScreen', () {
    testWidgets('renders Library title and profile icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Library'), findsOneWidget);
      expect(find.byIcon(Icons.account_circle), findsOneWidget);
    });

    testWidgets('renders navigation row for "Your uploads"', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final uploadsLabel = find.text('Your uploads');
      expect(uploadsLabel, findsOneWidget);

      expect(
        find.descendant(
          of: find.ancestor(of: uploadsLabel, matching: find.byType(Row)),
          matching: find.byIcon(Icons.chevron_right),
        ),
        findsOneWidget,
      );
    });

    testWidgets('navigates to profile when profile icon is tapped', (
      tester,
    ) async {
      final router = GoRouter(
        initialLocation: RoutePaths.library,
        routes: [
          GoRoute(
            path: RoutePaths.library,
            builder: (context, state) => const LibraryScreen(),
          ),
          GoRoute(
            path: RoutePaths.profile,
            builder: (context, state) => const Scaffold(body: Text('Profile')),
          ),
        ],
      );

      await tester.pumpWidget(buildTestWidget(router: router));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.account_circle));
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('navigates to uploads when navigation row tapped', (
      tester,
    ) async {
      final router = GoRouter(
        initialLocation: RoutePaths.library,
        routes: [
          GoRoute(
            path: RoutePaths.library,
            builder: (context, state) => const LibraryScreen(),
          ),
          GoRoute(
            path: RoutePaths.uploadLibrary,
            builder: (context, state) => const Scaffold(body: Text('Uploads')),
          ),
        ],
      );

      await tester.pumpWidget(buildTestWidget(router: router));

      await tester.tap(find.text('Your uploads'));
      await tester.pumpAndSettle();

      expect(find.text('Uploads'), findsOneWidget);
    });
  });
}
