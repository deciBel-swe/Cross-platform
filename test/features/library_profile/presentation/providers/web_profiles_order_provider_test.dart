import 'package:dartz/dartz.dart';
import 'package:decibel/features/library_profile/domain/entities/public_profile_social_links.dart';
import 'package:decibel/features/library_profile/domain/repositories/profile_repository.dart';
import 'package:decibel/features/library_profile/presentation/providers/web_profiles_order_provider.dart';
import 'package:decibel/features/library_profile/presentation/providers/web_profiles_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late ProviderContainer container;
  late MockProfileRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(const PublicProfileSocialLinks());
  });

  setUp(() {
    mockRepository = MockProfileRepository();
    container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWith((ref) => mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  WebProfilesOrderNotifier getNotifier() {
    return container.read(webProfilesOrderProvider.notifier);
  }

  group('WebProfilesOrderNotifier', () {
    test('initial state is empty', () {
      expect(container.read(webProfilesOrderProvider), isEmpty);
    });

    test('addPlatformIfMissing adds platform', () {
      getNotifier().addPlatformIfMissing('instagram');
      expect(container.read(webProfilesOrderProvider), ['instagram']);
    });

    test('addPlatformIfMissing does not duplicate platform', () {
      getNotifier().addPlatformIfMissing('instagram');
      getNotifier().addPlatformIfMissing('instagram');
      expect(container.read(webProfilesOrderProvider), ['instagram']);
    });

    test('removePlatform removes only that platform', () {
      getNotifier().addPlatformIfMissing('instagram');
      getNotifier().addPlatformIfMissing('youtube');
      getNotifier().addPlatformIfMissing('website');

      getNotifier().removePlatform('youtube');
      expect(container.read(webProfilesOrderProvider), [
        'instagram',
        'website',
      ]);
    });

    test('reorder changes order correctly', () {
      getNotifier().addPlatformIfMissing('instagram');
      getNotifier().addPlatformIfMissing('youtube');
      getNotifier().addPlatformIfMissing('website');

      getNotifier().reorder(0, 2);
      expect(container.read(webProfilesOrderProvider), [
        'youtube',
        'instagram',
        'website',
      ]);
    });

    test('updateOrder replaces the whole list', () {
      getNotifier().addPlatformIfMissing('instagram');
      getNotifier().updateOrder(['youtube', 'website']);
      expect(container.read(webProfilesOrderProvider), ['youtube', 'website']);
    });
  });

  group('orderedWebPlatformsProvider', () {
    test('combines saved order with new platforms correctly', () async {
      // 1. Setup mock repository for the profiles provider
      when(() => mockRepository.updateSocialLinks(any())).thenAnswer(
        (invocation) async => Right(
          invocation.positionalArguments[0] as PublicProfileSocialLinks,
        ),
      );

      // 2. Add some platforms to the profiles notifier
      await container
          .read(webProfilesProvider.notifier)
          .saveLink('https://instagram.com/test');
      await container
          .read(webProfilesProvider.notifier)
          .saveLink('https://youtube.com/@test');

      // 3. Initial ordered state should match order of addition (fallback)
      expect(container.read(orderedWebPlatformsProvider), [
        'instagram',
        'youtube',
      ]);

      // 4. Set a custom order
      getNotifier().updateOrder(['youtube', 'instagram']);

      // 5. Verify custom order is respected
      expect(container.read(orderedWebPlatformsProvider), [
        'youtube',
        'instagram',
      ]);

      // 6. Add a new platform not in custom order
      await container
          .read(webProfilesProvider.notifier)
          .saveLink('https://facebook.com/test');

      // 7. New platform should appear at the end (fallback)
      expect(container.read(orderedWebPlatformsProvider), [
        'youtube',
        'instagram',
        'facebook',
      ]);
    });
  });
}
