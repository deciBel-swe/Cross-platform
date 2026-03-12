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

    test('isEmpty returns true when all links are empty strings', () {
      const socialLinks = PublicProfileSocialLinks(
        instagram: '',
        twitter: '   ',
        website: '',
      );

      expect(socialLinks.isEmpty, true);
    });

    test('isEmpty returns false when at least one link has a real value', () {
      const socialLinks = PublicProfileSocialLinks(
        instagram: '   ',
        twitter: 'https://x.com/test_user',
        website: '',
      );

      expect(socialLinks.isEmpty, false);
    });
  });
}