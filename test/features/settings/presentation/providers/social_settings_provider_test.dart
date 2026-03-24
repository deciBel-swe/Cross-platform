import 'package:decibel/core/di/injection.dart';
import 'package:decibel/features/settings/domain/entities/social_settings.dart';
import 'package:decibel/features/settings/domain/repositories/social_settings_repository.dart';
import 'package:decibel/features/settings/presentation/providers/social_settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSocialSettingsRepository extends Mock
    implements SocialSettingsRepository {}

void main() {
  late MockSocialSettingsRepository mockRepository;

  setUp(() async {
    mockRepository = MockSocialSettingsRepository();
    when(() => mockRepository.getSocialSettings()).thenAnswer(
      (_) async => const SocialSettings(isPrivate: false, showHistory: true),
    );

    await getIt.reset();
    getIt.registerSingleton<SocialSettingsRepository>(mockRepository);
  });

  tearDown(() async {
    await getIt.reset();
  });

  test('reads SocialSettingsRepository from GetIt', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final repository = container.read(socialSettingsRepositoryProvider);

    expect(repository, same(mockRepository));
  });
}
