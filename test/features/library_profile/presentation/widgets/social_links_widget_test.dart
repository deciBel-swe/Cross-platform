import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:decibel/features/library_profile/models/public_profile_social_links.dart';
import 'package:decibel/features/library_profile/presentation/widgets/social_links_widget.dart';

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

    testWidgets('renders all buttons for non-null links', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SocialLinksWidget(
              socialLinks: PublicProfileSocialLinks(
                instagram: 'https://instagram.com/test_user',
                twitter: 'https://x.com/test_user',
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

    testWidgets('renders only website button when only website exists',
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
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('tapping Instagram calls launcher with correct URL',
        (tester) async {
      Uri? launchedUri;

      Future<bool> fakeLauncher(Uri uri) async {
        launchedUri = uri;
        return true;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialLinksWidget(
              socialLinks: const PublicProfileSocialLinks(
                instagram: 'https://instagram.com/test_user',
              ),
              launcher: fakeLauncher,
            ),
          ),
        ),
      );

      await tester.tap(find.byTooltip('Instagram'));
      await tester.pumpAndSettle();

      expect(launchedUri, Uri.parse('https://instagram.com/test_user'));
    });

    testWidgets('tapping Twitter/X calls launcher with correct URL',
        (tester) async {
      Uri? launchedUri;

      Future<bool> fakeLauncher(Uri uri) async {
        launchedUri = uri;
        return true;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialLinksWidget(
              socialLinks: const PublicProfileSocialLinks(
                twitter: 'https://x.com/test_user',
              ),
              launcher: fakeLauncher,
            ),
          ),
        ),
      );

      await tester.tap(find.byTooltip('Twitter/X'));
      await tester.pumpAndSettle();

      expect(launchedUri, Uri.parse('https://x.com/test_user'));
    });

    testWidgets('tapping Website calls launcher with correct URL',
        (tester) async {
      Uri? launchedUri;

      Future<bool> fakeLauncher(Uri uri) async {
        launchedUri = uri;
        return true;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialLinksWidget(
              socialLinks: const PublicProfileSocialLinks(
                website: 'https://example.com',
              ),
              launcher: fakeLauncher,
            ),
          ),
        ),
      );

      await tester.tap(find.byTooltip('Website'));
      await tester.pumpAndSettle();

      expect(launchedUri, Uri.parse('https://example.com'));
    });
  });
}