import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:decibel/features/library/presentation/widgets/social_links_widget.dart';
import 'package:decibel/features/library_profile/domain/entities/public_profile_social_links.dart';

void main() {
  group('SocialLinksWidget', () {
    testWidgets('renders nothing when all links are null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SocialLinksWidget(
              socialLinks: PublicProfileSocialLinks(),
            ),
          ),
        ),
      );

      expect(find.byType(IconButton), findsNothing);
      expect(find.byTooltip('Instagram'), findsNothing);
      expect(find.byTooltip('Twitter/X'), findsNothing);
      expect(find.byTooltip('Website'), findsNothing);
    });

    testWidgets('renders nothing when all links are empty strings',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SocialLinksWidget(
              socialLinks: PublicProfileSocialLinks(
                instagram: '',
                twitter: '   ',
                website: '',
              ),
            ),
          ),
        ),
      );

      expect(find.byType(IconButton), findsNothing);
      expect(find.byTooltip('Instagram'), findsNothing);
      expect(find.byTooltip('Twitter/X'), findsNothing);
      expect(find.byTooltip('Website'), findsNothing);
    });

    testWidgets('renders only instagram icon when instagram exists',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SocialLinksWidget(
              socialLinks: PublicProfileSocialLinks(
                instagram: 'https://instagram.com/test',
              ),
            ),
          ),
        ),
      );

      expect(find.byTooltip('Instagram'), findsOneWidget);
      expect(find.byTooltip('Twitter/X'), findsNothing);
      expect(find.byTooltip('Website'), findsNothing);
    });

    testWidgets('renders only twitter icon when twitter exists',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SocialLinksWidget(
              socialLinks: PublicProfileSocialLinks(
                twitter: 'https://x.com/test',
              ),
            ),
          ),
        ),
      );

      expect(find.byTooltip('Instagram'), findsNothing);
      expect(find.byTooltip('Twitter/X'), findsOneWidget);
      expect(find.byTooltip('Website'), findsNothing);
    });

    testWidgets('renders only website icon when website exists',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SocialLinksWidget(
              socialLinks: PublicProfileSocialLinks(
                website: 'https://example.com',
              ),
            ),
          ),
        ),
      );

      expect(find.byTooltip('Instagram'), findsNothing);
      expect(find.byTooltip('Twitter/X'), findsNothing);
      expect(find.byTooltip('Website'), findsOneWidget);
    });

    testWidgets('renders all icons when all links exist', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SocialLinksWidget(
              socialLinks: PublicProfileSocialLinks(
                instagram: 'https://instagram.com/test',
                twitter: 'https://x.com/test',
                website: 'https://example.com',
              ),
            ),
          ),
        ),
      );

      expect(find.byTooltip('Instagram'), findsOneWidget);
      expect(find.byTooltip('Twitter/X'), findsOneWidget);
      expect(find.byTooltip('Website'), findsOneWidget);
      expect(find.byType(IconButton), findsNWidgets(3));
    });
  });
}