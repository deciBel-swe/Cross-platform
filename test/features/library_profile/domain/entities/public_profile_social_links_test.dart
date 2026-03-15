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
        youtube: '',
        tiktok: '',
        linkedin: '',
        snapchat: '',
        facebook: '',
        website: '',
      );

      expect(socialLinks.isEmpty, true);
    });

    test('isEmpty returns false when one platform exists', () {
      const socialLinks = PublicProfileSocialLinks(
        youtube: 'https://youtube.com/@test',
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
      expect(updated.youtube, isNull);
      expect(updated.website, isNull);
    });

    test('copyWith updates only youtube', () {
      const socialLinks = PublicProfileSocialLinks(
        instagram: 'https://instagram.com/test',
      );

      final updated = socialLinks.copyWith(
        youtube: 'https://youtube.com/@test',
      );

      expect(updated.instagram, 'https://instagram.com/test');
      expect(updated.youtube, 'https://youtube.com/@test');
      expect(updated.twitter, isNull);
    });

    test('copyWith updates website only', () {
      const socialLinks = PublicProfileSocialLinks(
        facebook: 'https://facebook.com/test',
      );

      final updated = socialLinks.copyWith(
        website: 'https://example.com',
      );

      expect(updated.facebook, 'https://facebook.com/test');
      expect(updated.website, 'https://example.com');
      expect(updated.instagram, isNull);
    });
  });
}