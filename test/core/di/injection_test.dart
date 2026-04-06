import 'package:decibel/core/di/injection.dart';
import 'package:decibel/features/library_profile/data/repositories/mock_genre_repository_impl.dart';
import 'package:decibel/features/library_profile/data/repositories/mock_profile_repository_impl.dart';
import 'package:decibel/features/library_profile/domain/repositories/genre_repository.dart';
import 'package:decibel/features/library_profile/domain/repositories/profile_repository.dart';
import 'package:decibel/features/settings/data/repositories/mock_social_settings_repository_impl.dart';
import 'package:decibel/features/settings/data/repositories/social_settings_repository_impl.dart';
import 'package:decibel/features/settings/domain/repositories/social_settings_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    dotenv.testLoad(
      fileInput:
          'API_BASE_URL=http://localhost:8082/api\n'
          'GOOGLE_MOBILE_CLIENT_ID=test-mobile-client-id\n'
          'GOOGLE_DESKTOP_CLIENT_ID=test-desktop-client-id',
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('configureDependencies', () {
    test('registers mock repositories when useMockServices is true', () {
      configureDependencies(useMockServices: true);

      expect(
        getIt<SocialSettingsRepository>(),
        isA<MockSocialSettingsRepository>(),
      );
      expect(getIt<ProfileRepository>(), isA<MockProfileRepository>());
      expect(getIt<AllGenresRepository>(), isA<MockAllGenresRepository>());
    });

    test(
      'registers production social settings repository when useMockServices is false',
      () {
        configureDependencies(useMockServices: false);

        expect(
          getIt<SocialSettingsRepository>(),
          isA<SocialSettingsRepositoryImpl>(),
        );
      },
    );
  });
}
