import 'package:decibel/core/storage/secure_storage_service.dart';
import 'package:decibel/features/library/presentation/providers/web_profiles_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeSecureStorageService extends SecureStorageService {
  FakeSecureStorageService() : super(const FlutterSecureStorage());

  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> getRefreshToken() async => null;
}

void main() {
  group('WebProfilesNotifier Tests', () {
    late WebProfilesNotifier notifier;

    setUp(() {
      notifier = WebProfilesNotifier(FakeSecureStorageService());
    });

    test('Initial state should have all links null', () {
      final state = notifier.state;

      expect(state.instagram, isNull);
      expect(state.twitter, isNull);
      expect(state.youtube, isNull);
      expect(state.tiktok, isNull);
      expect(state.linkedin, isNull);
      expect(state.snapchat, isNull);
      expect(state.facebook, isNull);
      expect(state.website, isNull);
      expect(state.supportLink, isNull);
    });

    test('Save Instagram link', () async {
      await notifier.saveLink('https://instagram.com/test');
      expect(notifier.state.instagram, 'https://instagram.com/test');
    });

    test('Save Twitter/X link', () async {
      await notifier.saveLink('https://x.com/test');
      expect(notifier.state.twitter, 'https://x.com/test');
    });

    test('Save YouTube link', () async {
      await notifier.saveLink('https://youtube.com/@test');
      expect(notifier.state.youtube, 'https://youtube.com/@test');
    });

    test('Save TikTok link', () async {
      await notifier.saveLink('https://tiktok.com/@test');
      expect(notifier.state.tiktok, 'https://tiktok.com/@test');
    });

    test('Save LinkedIn link', () async {
      await notifier.saveLink('https://linkedin.com/in/test');
      expect(notifier.state.linkedin, 'https://linkedin.com/in/test');
    });

    test('Save Snapchat link', () async {
      await notifier.saveLink('https://snapchat.com/add/test');
      expect(notifier.state.snapchat, 'https://snapchat.com/add/test');
    });

    test('Save Facebook link', () async {
      await notifier.saveLink('https://facebook.com/test');
      expect(notifier.state.facebook, 'https://facebook.com/test');
    });

    test('Save generic website link', () async {
      await notifier.saveLink('https://myportfolio.dev');
      expect(notifier.state.website, 'https://myportfolio.dev');
    });

    test('Save support link', () async {
      await notifier.saveLink('https://patreon.com/test');
      expect(notifier.state.supportLink, 'https://patreon.com/test');
    });

    test('linkAlreadyExists returns true for exact existing link', () async {
      await notifier.saveLink('https://instagram.com/test');

      expect(notifier.linkAlreadyExists('https://instagram.com/test'), true);
    });

    test('linkAlreadyExists returns false for non-existing link', () async {
      await notifier.saveLink('https://instagram.com/test');

      expect(notifier.linkAlreadyExists('https://instagram.com/other'), false);
    });

    test('platformAlreadyExists returns true for same platform', () async {
      await notifier.saveLink('https://instagram.com/test');

      expect(
        notifier.platformAlreadyExists('https://instagram.com/another'),
        true,
      );
    });

    test('platformAlreadyExists returns false when platform not saved', () {
      expect(
        notifier.platformAlreadyExists('https://youtube.com/@test'),
        false,
      );
    });

    test(
      'getExistingLinkForPlatform returns correct stored instagram link',
      () async {
        await notifier.saveLink('https://instagram.com/test');

        expect(
          notifier.getExistingLinkForPlatform('https://instagram.com/another'),
          'https://instagram.com/test',
        );
      },
    );

    test(
      'getExistingLinkForPlatform returns correct stored youtube link',
      () async {
        await notifier.saveLink('https://youtube.com/@test');

        expect(
          notifier.getExistingLinkForPlatform('https://youtube.com/@another'),
          'https://youtube.com/@test',
        );
      },
    );

    test('getPlatformKey returns correct platform for youtube', () {
      expect(notifier.getPlatformKey('https://youtube.com/@test'), 'youtube');
    });

    test('getPlatformKey returns website for unknown domain', () {
      expect(notifier.getPlatformKey('https://unknown-domain.dev'), 'website');
    });

    test('getPlatformKey returns supportLink for patreon', () {
      expect(
        notifier.getPlatformKey('https://patreon.com/test'),
        'supportLink',
      );
    });

    test('isSamePlatform returns true for same platform', () {
      final result = notifier.isSamePlatform(
        'https://instagram.com/test',
        'https://instagram.com/new',
      );

      expect(result, true);
    });

    test('isSamePlatform returns false for different platforms', () {
      final result = notifier.isSamePlatform(
        'https://instagram.com/test',
        'https://youtube.com/@test',
      );

      expect(result, false);
    });

    test('Edit link correctly for Instagram', () async {
      await notifier.saveLink('https://instagram.com/test');

      await notifier.editLink(
        'https://instagram.com/test',
        'https://instagram.com/newtest',
      );

      expect(notifier.state.instagram, 'https://instagram.com/newtest');
    });

    test('Edit link correctly for YouTube', () async {
      await notifier.saveLink('https://youtube.com/@old');

      await notifier.editLink(
        'https://youtube.com/@old',
        'https://youtube.com/@new',
      );

      expect(notifier.state.youtube, 'https://youtube.com/@new');
    });

    test('Edit link correctly for Website', () async {
      await notifier.saveLink('https://example.com');

      await notifier.editLink('https://example.com', 'https://newexample.com');

      expect(notifier.state.website, 'https://newexample.com');
    });

    test('Edit link from one platform to another', () async {
      await notifier.saveLink('https://instagram.com/test');

      await notifier.editLink(
        'https://instagram.com/test',
        'https://youtube.com/@new',
      );

      expect(notifier.state.instagram, isNull);
      expect(notifier.state.youtube, 'https://youtube.com/@new');
    });

    test('Delete link correctly for Instagram', () async {
      await notifier.saveLink('https://instagram.com/test');

      await notifier.deleteLink('https://instagram.com/test');

      expect(notifier.state.instagram, isNull);
    });

    test('Delete link correctly for YouTube', () async {
      await notifier.saveLink('https://youtube.com/@test');

      await notifier.deleteLink('https://youtube.com/@test');

      expect(notifier.state.youtube, '');
    });

    test('Deleting one platform does not remove another', () async {
      await notifier.saveLink('https://instagram.com/test');
      await notifier.saveLink('https://youtube.com/@test');

      await notifier.deleteLink('https://instagram.com/test');

      expect(notifier.state.instagram, isNull);
      expect(notifier.state.youtube, 'https://youtube.com/@test');
    });

    test('Deleting non-existing exact link does not change state', () async {
      await notifier.saveLink('https://facebook.com/test');

      await notifier.deleteLink('https://facebook.com/other');

      expect(notifier.state.facebook, '');
    });
  });
}
