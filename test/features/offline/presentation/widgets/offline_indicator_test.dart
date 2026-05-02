import 'package:decibel/features/offline/presentation/widgets/offline_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('OfflineIndicator', () {
    testWidgets('renders wifi-off icon', (tester) async {
      await tester.pumpWidget(_wrap(const OfflineIndicator()));
      expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
    });

    testWidgets('renders "No Internet Connection" title', (tester) async {
      await tester.pumpWidget(_wrap(const OfflineIndicator()));
      expect(find.text('No Internet Connection'), findsOneWidget);
    });

    testWidgets('renders offline content message', (tester) async {
      await tester.pumpWidget(_wrap(const OfflineIndicator()));
      expect(
        find.textContaining('Offline content is still available'),
        findsOneWidget,
      );
    });

    testWidgets('does NOT render Retry button when onRetry is null', (tester) async {
      await tester.pumpWidget(_wrap(const OfflineIndicator()));
      expect(find.text('Retry'), findsNothing);
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('renders Retry button when onRetry callback is provided', (tester) async {
      await tester.pumpWidget(_wrap(OfflineIndicator(onRetry: () {})));
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
    });

    testWidgets('tapping Retry invokes the callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(OfflineIndicator(onRetry: () => tapped = true)),
      );

      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('tapping Retry invokes callback exactly once', (tester) async {
      var tapCount = 0;
      await tester.pumpWidget(
        _wrap(OfflineIndicator(onRetry: () => tapCount++)),
      );

      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(tapCount, 1);
    });

    testWidgets('widget is centered on screen', (tester) async {
      await tester.pumpWidget(_wrap(const OfflineIndicator()));
      // The root of OfflineIndicator is a Center widget.
      expect(find.byType(Center), findsWidgets);
    });
  });
}
