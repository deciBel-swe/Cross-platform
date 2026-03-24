import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library_profile/presentation/providers/uploads_provider.dart';
import 'package:decibel/features/library_profile/presentation/providers/uploads_scroll_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeUploadsNotifier extends UploadsNotifier {
  FakeUploadsNotifier(this.onLoadNextPage);

  final VoidCallback onLoadNextPage;

  @override
  Future<List<Track>> build() async => const <Track>[];

  @override
  Future<void> loadNextPage() async {
    onLoadNextPage();
  }
}

void main() {
  late int loadNextPageCalls;

  setUp(() {
    loadNextPageCalls = 0;
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        uploadsProvider.overrideWith(
          () => FakeUploadsNotifier(() => loadNextPageCalls++),
        ),
      ],
    );
  }

  group('uploadsScrollControllerProvider', () {
    testWidgets('ScrollController is created and disposed correctly', (
      tester,
    ) async {
      final container = createContainer();

      ScrollController? controller;

      // Build a widget to use the provider
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: Builder(
            builder: (context) {
              // Read the provider
              controller = container.read(uploadsScrollControllerProvider);
              return Container();
            },
          ),
        ),
      );

      expect(controller, isNotNull);
      expect(controller!.hasClients, isFalse);

      // Verify disposal behavior
      // Manually dispose the container to trigger onDispose
      container.dispose();

      // ScrollController.dispose() should have been called, but we can't easily spy on the exact instance method call without a mock.
      // However, we rely on the provider implementation being correct in calling dispose.
      // If we try to access it after disposal, it should throw in debug mode usually.
      expect(() => controller!.dispose(), throwsFlutterError);
    });

    // To test the scroll listener logic requires attaching the controller to a real Scrollable
    testWidgets('Scroll listener triggers loadNextPage near bottom', (
      tester,
    ) async {
      final container = createContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) {
                  final controller = ref.watch(uploadsScrollControllerProvider);
                  return ListView.builder(
                    controller: controller,
                    // Use a fixed item extent to make math easy
                    itemExtent: 100,
                    // Enough items to be scrollable
                    itemCount: 20,
                    itemBuilder: (c, i) =>
                        SizedBox(height: 100, child: Text('Item $i')),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Total height roughly 20 * 100 = 2000.
      // Viewport e.g. 600. maxScrollExtent ~ 1400.

      final scrollable = find.byType(Scrollable);
      final scrollState = tester.state<ScrollableState>(scrollable);

      // Scroll to nearly bottom (within 200px threshold)
      // Let's jump to the very end
      scrollState.position.jumpTo(scrollState.position.maxScrollExtent);

      // Allow listener to fire
      await tester.pump();

      // Verify loadNextPage called
      expect(loadNextPageCalls, 1);
    });

    testWidgets(
      'Scroll listener does NOT trigger loadNextPage when far from bottom',
      (tester) async {
        final container = createContainer();

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(
                body: Consumer(
                  builder: (context, ref, _) {
                    final controller = ref.watch(
                      uploadsScrollControllerProvider,
                    );
                    return ListView.builder(
                      controller: controller,
                      itemExtent: 100,
                      itemCount: 20,
                      itemBuilder: (c, i) =>
                          SizedBox(height: 100, child: Text('Item $i')),
                    );
                  },
                ),
              ),
            ),
          ),
        );

        final scrollable = find.byType(Scrollable);
        final scrollState = tester.state<ScrollableState>(scrollable);

        // Scroll only a little bit (top)
        scrollState.position.jumpTo(100.0);

        // Allow listener to fire
        await tester.pump();

        // Verify loadNextPage NOT called
        expect(loadNextPageCalls, 0);
      },
    );
  });
}
