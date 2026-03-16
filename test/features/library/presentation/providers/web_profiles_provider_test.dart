import 'package:decibel/features/library/presentation/providers/web_profiles_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WebProfilesNotifier', () {
    test('initial state is empty', () {
      final notifier = WebProfilesNotifier();

      expect(notifier.state.instagram, null);
      expect(notifier.state.twitter, null);
      expect(notifier.state.website, null);
      expect(notifier.state.isEmpty, true);
    });

    test('saveLink stores instagram link correctly', () {
      final notifier = WebProfilesNotifier();

      notifier.saveLink('https://instagram.com/test_user');

      expect(notifier.state.instagram, 'https://instagram.com/test_user');
      expect(notifier.state.twitter, null);
      expect(notifier.state.website, null);
    });

    test('saveLink stores twitter/x link correctly', () {
      final notifier = WebProfilesNotifier();

      notifier.saveLink('https://x.com/test_user');

      expect(notifier.state.instagram, null);
      expect(notifier.state.twitter, 'https://x.com/test_user');
      expect(notifier.state.website, null);
    });

    test('saveLink stores website link correctly', () {
      final notifier = WebProfilesNotifier();

      notifier.saveLink('https://example.com');

      expect(notifier.state.instagram, null);
      expect(notifier.state.twitter, null);
      expect(notifier.state.website, 'https://example.com');
    });

    test('saveLink keeps previous values when adding another platform', () {
      final notifier = WebProfilesNotifier();

      notifier.saveLink('https://instagram.com/test_user');
      notifier.saveLink('https://x.com/test_user');
      notifier.saveLink('https://example.com');

      expect(notifier.state.instagram, 'https://instagram.com/test_user');
      expect(notifier.state.twitter, 'https://x.com/test_user');
      expect(notifier.state.website, 'https://example.com');
    });
  });
}