import 'package:decibel/core/errors/exceptions.dart';
import 'package:decibel/core/widgets/app_error_widget.dart';
import 'package:decibel/features/offline/presentation/widgets/offline_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestableWidget(Widget widget) {
    return MaterialApp(home: Scaffold(body: widget));
  }

  group('AppErrorWidget', () {
    testWidgets('shows OfflineIndicator when error is NetworkException', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestableWidget(const AppErrorWidget(error: NetworkException())),
      );

      expect(find.byType(OfflineIndicator), findsOneWidget);
    });

    testWidgets('shows normal error view when error is ServerException', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const AppErrorWidget(
            error: ServerException('My custom server error'),
          ),
        ),
      );

      expect(find.byType(OfflineIndicator), findsNothing);
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('My custom server error'), findsOneWidget);
    });
  });
}
