import 'package:flutter_test/flutter_test.dart';
import 'package:decibel/features/library/presentation/providers/web_profiles_provider.dart';

void main() {

  group('WebProfilesNotifier - Save', () {

    test('save instagram link', () {
      final notifier = WebProfilesNotifier();

      notifier.saveLink('https://instagram.com/test');

      expect(notifier.state.instagram, 'https://instagram.com/test');
    });

    test('save twitter link', () {
      final notifier = WebProfilesNotifier();

      notifier.saveLink('https://x.com/test');

      expect(notifier.state.twitter, 'https://x.com/test');
    });

    test('save website link', () {
      final notifier = WebProfilesNotifier();

      notifier.saveLink('https://example.com');

      expect(notifier.state.website, 'https://example.com');
    });

  });

  group('WebProfilesNotifier - Edit', () {

    test('edit instagram link', () {
      final notifier = WebProfilesNotifier();

      notifier.saveLink('https://instagram.com/old');
      notifier.editLink('https://instagram.com/new');

      expect(notifier.state.instagram, 'https://instagram.com/new');
    });

    test('edit twitter link', () {
      final notifier = WebProfilesNotifier();

      notifier.saveLink('https://x.com/old');
      notifier.editLink('https://x.com/new');

      expect(notifier.state.twitter, 'https://x.com/new');
    });

  });

  group('WebProfilesNotifier - Delete', () {

    test('delete instagram link', () {
      final notifier = WebProfilesNotifier();

      notifier.saveLink('https://instagram.com/test');
      notifier.deleteLink('https://instagram.com/test');

      expect(notifier.state.instagram, '');
    });

    test('delete twitter link', () {
      final notifier = WebProfilesNotifier();

      notifier.saveLink('https://x.com/test');
      notifier.deleteLink('https://x.com/test');

      expect(notifier.state.twitter, '');
    });

    test('delete website link', () {
      final notifier = WebProfilesNotifier();

      notifier.saveLink('https://example.com');
      notifier.deleteLink('https://example.com');

      expect(notifier.state.website, '');
    });

  });

  group('WebProfilesNotifier - Helpers', () {

    test('linkAlreadyExists returns true for existing link', () {
      final notifier = WebProfilesNotifier();

      notifier.saveLink('https://example.com');

      expect(notifier.linkAlreadyExists('https://example.com'), true);
    });

    test('platformAlreadyExists returns true if platform exists', () {
      final notifier = WebProfilesNotifier();

      notifier.saveLink('https://instagram.com/test');

      expect(
        notifier.platformAlreadyExists('https://instagram.com/another'),
        true,
      );
    });

    test('getExistingLinkForPlatform returns correct link', () {
      final notifier = WebProfilesNotifier();

      notifier.saveLink('https://x.com/test');

      expect(
        notifier.getExistingLinkForPlatform('https://x.com/anything'),
        'https://x.com/test',
      );
    });

  });

}