import 'package:flutter_test/flutter_test.dart';
import 'package:decibel/features/library_profile/domain/entities/public_profile_social_links.dart';

void main() {
  group('PublicProfileSocialLinks', () {
    test('isEmpty returns true when all links are null', () {
      const socialLinks = PublicProfileSocialLinks();

      expect(socialLinks.isEmpty, true);
    });

    test('isEmpty returns false when instagram is not null', () {
      const socialLinks = PublicProfileSocialLinks(
        instagram: 'https://instagram.com/test_user',
      );

      expect(socialLinks.isEmpty, false);
    });

    test('isEmpty returns false when twitter is not null', () {
      const socialLinks = PublicProfileSocialLinks(
        twitter: 'https://x.com/test_user',
      );

      expect(socialLinks.isEmpty, false);
    });

    test('isEmpty returns false when website is not null', () {
      const socialLinks = PublicProfileSocialLinks(
        website: 'https://example.com',
      );

      expect(socialLinks.isEmpty, false);
    });

    test('copyWith updates only instagram', () {
      const socialLinks = PublicProfileSocialLinks(
        twitter: 'https://x.com/test_user',
      );

      final updated = socialLinks.copyWith(
        instagram: 'https://instagram.com/test_user',
      );

      expect(updated.instagram, 'https://instagram.com/test_user');
      expect(updated.twitter, 'https://x.com/test_user');
      expect(updated.website, null);
    });
  });
}