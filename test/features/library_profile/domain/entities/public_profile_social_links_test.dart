import 'package:flutter_test/flutter_test.dart';
import 'package:decibel/features/library_profile/domain/entities/public_profile_social_links.dart';

void main() {
  group('PublicProfileSocialLinks', () {
    test('isEmpty returns true when all links are null', () {
      const socialLinks = PublicProfileSocialLinks();

      expect(socialLinks.isEmpty, true);
    });

    test('isEmpty returns true when all links are empty strings', () {
      const socialLinks = PublicProfileSocialLinks(
        instagram: '',
        twitter: '   ',
        website: '',
      );

      expect(socialLinks.isEmpty, true);
    });

    test('isEmpty returns false when instagram exists', () {
      const socialLinks = PublicProfileSocialLinks(
        instagram: 'https://instagram.com/test',
      );

      expect(socialLinks.isEmpty, false);
    });

    test('copyWith updates only instagram', () {
      const socialLinks = PublicProfileSocialLinks(
        twitter: 'https://x.com/test',
      );

      final updated = socialLinks.copyWith(
        instagram: 'https://instagram.com/test',
      );

      expect(updated.instagram, 'https://instagram.com/test');
      expect(updated.twitter, 'https://x.com/test');
      expect(updated.website, null);
    });

    test('copyWith updates website only', () {
      const socialLinks = PublicProfileSocialLinks(
        instagram: 'https://instagram.com/test',
      );

      final updated = socialLinks.copyWith(
        website: 'https://example.com',
      );

      expect(updated.instagram, 'https://instagram.com/test');
      expect(updated.website, 'https://example.com');
      expect(updated.twitter, null);
    });
  });
}