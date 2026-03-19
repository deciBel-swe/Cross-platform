import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:decibel/features/library_profile/domain/entities/public_profile_social_links.dart';
import 'package:decibel/features/library_profile/presentation/widgets/social_links_widget.dart';

void main() {
  Widget buildTestWidget(PublicProfileSocialLinks socialLinks) {
    return ProviderScope(
      child: MaterialApp(
        home: Scaffold(body: SocialLinksWidget(socialLinks: socialLinks)),
      ),
    );
  }

  group('SocialLinksWidget', () {
    testWidgets('renders nothing when all links are null', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const PublicProfileSocialLinks()),
      );

      expect(find.byType(IconButton), findsNothing);
      expect(find.byTooltip('instagram'), findsNothing);
      expect(find.byTooltip('twitter'), findsNothing);
      expect(find.byTooltip('youtube'), findsNothing);
      expect(find.byTooltip('tiktok'), findsNothing);
      expect(find.byTooltip('linkedin'), findsNothing);
      expect(find.byTooltip('snapchat'), findsNothing);
      expect(find.byTooltip('facebook'), findsNothing);
      expect(find.byTooltip('website'), findsNothing);
    });

    testWidgets('renders nothing when all links are empty strings', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const PublicProfileSocialLinks(
            instagram: '',
            twitter: '   ',
            youtube: '',
            tiktok: '',
            linkedin: '',
            snapchat: '',
            facebook: '',
            website: '',
          ),
        ),
      );

      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets('renders only instagram icon when instagram exists', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const PublicProfileSocialLinks(
            instagram: 'https://instagram.com/test',
          ),
        ),
      );

      expect(find.byTooltip('instagram'), findsOneWidget);
      expect(find.byTooltip('twitter'), findsNothing);
      expect(find.byTooltip('website'), findsNothing);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('renders only twitter icon when twitter exists', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const PublicProfileSocialLinks(twitter: 'https://x.com/test'),
        ),
      );

      expect(find.byTooltip('instagram'), findsNothing);
      expect(find.byTooltip('twitter'), findsOneWidget);
      expect(find.byTooltip('website'), findsNothing);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('renders only website icon when website exists', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const PublicProfileSocialLinks(website: 'https://example.com'),
        ),
      );

      expect(find.byTooltip('instagram'), findsNothing);
      expect(find.byTooltip('twitter'), findsNothing);
      expect(find.byTooltip('website'), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('renders only youtube icon when youtube exists', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const PublicProfileSocialLinks(youtube: 'https://youtube.com/@test'),
        ),
      );

      expect(find.byTooltip('youtube'), findsOneWidget);
      expect(find.byTooltip('website'), findsNothing);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('renders only tiktok icon when tiktok exists', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const PublicProfileSocialLinks(tiktok: 'https://tiktok.com/@test'),
        ),
      );

      expect(find.byTooltip('tiktok'), findsOneWidget);
      expect(find.byTooltip('website'), findsNothing);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('renders all icons when all links exist', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const PublicProfileSocialLinks(
            instagram: 'https://instagram.com/test',
            twitter: 'https://x.com/test',
            youtube: 'https://youtube.com/@test',
            tiktok: 'https://tiktok.com/@test',
            linkedin: 'https://linkedin.com/in/test',
            snapchat: 'https://snapchat.com/add/test',
            facebook: 'https://facebook.com/test',
            website: 'https://example.com',
          ),
        ),
      );

      expect(find.byTooltip('instagram'), findsOneWidget);
      expect(find.byTooltip('twitter'), findsOneWidget);
      expect(find.byTooltip('youtube'), findsOneWidget);
      expect(find.byTooltip('tiktok'), findsOneWidget);
      expect(find.byTooltip('linkedin'), findsOneWidget);
      expect(find.byTooltip('snapchat'), findsOneWidget);
      expect(find.byTooltip('facebook'), findsOneWidget);
      expect(find.byTooltip('website'), findsOneWidget);
    });
  });
}
