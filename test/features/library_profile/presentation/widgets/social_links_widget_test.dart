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

void main() {
  group('SocialLinksWidget', () {
    testWidgets('renders nothing when all links are null', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const PublicProfileSocialLinks()),
      );

      expect(find.byType(IconButton), findsNothing);
      expect(find.byTooltip('Open instagram link'), findsNothing);
      expect(find.byTooltip('Open twitter link'), findsNothing);
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

      await tester.pumpAndSettle();

      expect(find.byTooltip('Open instagram link'), findsOneWidget);
      expect(find.byTooltip('Open twitter link'), findsNothing);
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

      await tester.pumpAndSettle();

      expect(find.byTooltip('Open instagram link'), findsOneWidget);
      expect(find.byTooltip('Open twitter link'), findsOneWidget);
      expect(find.byTooltip('Open youtube link'), findsNothing);
      expect(find.byTooltip('Open tiktok link'), findsNothing);
      expect(find.byTooltip('Open linkedin link'), findsNothing);
      expect(find.byTooltip('Open snapchat link'), findsNothing);
      expect(find.byTooltip('Open facebook link'), findsNothing);
      expect(find.byTooltip('Open website link'), findsNothing);
      expect(find.byType(IconButton), findsNWidgets(2));
    });
  });
}
