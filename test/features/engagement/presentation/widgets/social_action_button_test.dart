import 'package:decibel/features/engagement/presentation/widgets/social_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SocialActionButton', () {
    testWidgets('renders active state correctly', (tester) async {
      bool toggled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialActionButton(
              isActive: true,
              count: 10,
              isLoading: false,
              activeIcon: Icons.favorite,
              inactiveIcon: Icons.favorite_border,
              activeColor: Colors.red,
              onToggle: () => toggled = true,
              identifier: 'like',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      
      final iconSemantics = tester.getSemantics(find.byType(Icon));
      expect(iconSemantics.label, 'Active');

      await tester.tap(find.byType(Icon));
      expect(toggled, isTrue);
    });

    testWidgets('renders inactive state correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SocialActionButton(
              isActive: false,
              count: 5,
              isLoading: false,
              activeIcon: Icons.favorite,
              inactiveIcon: Icons.favorite_border,
              activeColor: Colors.red,
              onToggle: _noop,
              identifier: 'like',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      
      final iconSemantics = tester.getSemantics(find.byType(Icon));
      expect(iconSemantics.label, 'Inactive');
    });

    testWidgets('handles loading state', (tester) async {
      bool toggled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialActionButton(
              isActive: false,
              count: 5,
              isLoading: true,
              activeIcon: Icons.favorite,
              inactiveIcon: Icons.favorite_border,
              activeColor: Colors.red,
              onToggle: () => toggled = true,
              identifier: 'like',
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Icon));
      expect(toggled, isFalse);
    });

    testWidgets('calls onCountTap when provided', (tester) async {
      bool countTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialActionButton(
              isActive: false,
              count: 5,
              isLoading: false,
              activeIcon: Icons.favorite,
              inactiveIcon: Icons.favorite_border,
              activeColor: Colors.red,
              onToggle: _noop,
              onCountTap: () => countTapped = true,
              identifier: 'like',
            ),
          ),
        ),
      );

      await tester.tap(find.text('5'));
      expect(countTapped, isTrue);
    });
  });
}

void _noop() {}
