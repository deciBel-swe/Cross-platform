import 'package:decibel/features/library_profile/domain/entities/public_profile_social_links.dart';
import 'package:decibel/features/library_profile/presentation/providers/web_profiles_provider.dart';
import 'package:decibel/features/library_profile/presentation/widgets/social_links_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MockWebProfilesNotifier extends WebProfilesNotifier {
  MockWebProfilesNotifier(this._initialState);
  final PublicProfileSocialLinks _initialState;

  @override
  PublicProfileSocialLinks build() => _initialState;
}

void main() {
  Widget buildTestWidget(PublicProfileSocialLinks socialLinks) {
    return ProviderScope(
      overrides: [
        webProfilesProvider.overrideWith(
          () => MockWebProfilesNotifier(socialLinks),
        ),
      ],
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
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('renders only first two icons when many links exist', (
      tester,
    ) async {
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
      expect(find.byTooltip('youtube'), findsNothing);
      expect(find.byTooltip('tiktok'), findsNothing);
      expect(find.byTooltip('linkedin'), findsNothing);
      expect(find.byTooltip('snapchat'), findsNothing);
      expect(find.byTooltip('facebook'), findsNothing);
      expect(find.byTooltip('website'), findsNothing);
      expect(find.byType(IconButton), findsNWidgets(2));
    });
  });
}
