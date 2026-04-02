import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/library_profile/domain/entities/public_profile_social_links.dart';
import 'package:decibel/features/library_profile/domain/repositories/profile_repository.dart';
import 'package:decibel/features/library_profile/presentation/providers/web_profiles_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

// Fake failure for testing
class TestFailure extends Failure {
  const TestFailure(super.message);
}

void main() {
  late MockProfileRepository mockRepository;
  late ProviderContainer container;

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

  WebProfilesNotifier getNotifier() {
    return container.read(webProfilesProvider.notifier);
  }

  group('WebProfilesNotifier Tests', () {
    test('Initial state should be empty PublicProfileSocialLinks', () {
      final state = container.read(webProfilesProvider);
      expect(state.isEmpty, isTrue);
      expect(state.instagram, isNull);
    });

    test('saveLink updates state and calls repository', () async {
      final notifier = getNotifier();
      const link = 'https://instagram.com/test';

      when(() => mockRepository.updateSocialLinks(any())).thenAnswer(
        (_) async => const Right(PublicProfileSocialLinks(instagram: link)),
      );

      final result = await notifier.saveLink(link);

      expect(result, isTrue);
      expect(container.read(webProfilesProvider).instagram, link);
      verify(() => mockRepository.updateSocialLinks(any())).called(1);
    });

    test('saveLink rolls back state on repository failure', () async {
      final notifier = getNotifier();
      const link = 'https://instagram.com/test';

      when(
        () => mockRepository.updateSocialLinks(any()),
      ).thenAnswer((_) async => const Left(TestFailure('Error')));

      final result = await notifier.saveLink(link);

      expect(result, isFalse);
      expect(container.read(webProfilesProvider).instagram, isNull);
    });

    test('editLink updates state for same platform', () async {
      final notifier = getNotifier();
      const oldLink = 'https://instagram.com/old';
      const newLink = 'https://instagram.com/new';

      when(() => mockRepository.updateSocialLinks(any())).thenAnswer(
        (_) async => Right(
          const PublicProfileSocialLinks().copyWithPlatform(
            'instagram',
            newLink,
          ),
        ),
      );

      await notifier.saveLink(oldLink);
      final result = await notifier.editLink(oldLink, newLink);

      expect(result, isTrue);
      expect(container.read(webProfilesProvider).instagram, newLink);
    });

    test('editLink updates state for different platforms', () async {
      final notifier = getNotifier();
      const oldLink = 'https://instagram.com/test';
      const newLink = 'https://youtube.com/@new';

      when(() => mockRepository.updateSocialLinks(any())).thenAnswer(
        (_) async => Right(
          const PublicProfileSocialLinks().copyWithPlatform('youtube', newLink),
        ),
      );

      await notifier.saveLink(oldLink);
      final result = await notifier.editLink(oldLink, newLink);

      expect(result, isTrue);
      expect(container.read(webProfilesProvider).instagram, isNull);
      expect(container.read(webProfilesProvider).youtube, newLink);
    });

    test('deleteLink clears the correct platform', () async {
      final notifier = getNotifier();
      const link = 'https://instagram.com/test';

      when(
        () => mockRepository.updateSocialLinks(any()),
      ).thenAnswer((_) async => const Right(PublicProfileSocialLinks()));

      await notifier.saveLink(link);
      final result = await notifier.deleteLink(link);

      expect(result, isTrue);
      expect(container.read(webProfilesProvider).instagram, isNull);
    });

    test('linkAlreadyExists returns true for matching link', () async {
      final notifier = getNotifier();
      const link = ' https://instagram.com/test  ';

      when(() => mockRepository.updateSocialLinks(any())).thenAnswer(
        (_) async => const Right(
          PublicProfileSocialLinks(instagram: 'https://instagram.com/test'),
        ),
      );

      await notifier.saveLink(link);

      expect(notifier.linkAlreadyExists('https://instagram.com/test'), isTrue);
      expect(
        notifier.linkAlreadyExists('https://instagram.com/other'),
        isFalse,
      );
    });

    test('platformAlreadyExists returns true for matching platform', () async {
      final notifier = getNotifier();
      const link = 'https://instagram.com/test';

      when(() => mockRepository.updateSocialLinks(any())).thenAnswer(
        (_) async => const Right(PublicProfileSocialLinks(instagram: link)),
      );

      await notifier.saveLink(link);

      expect(
        notifier.platformAlreadyExists('https://instagram.com/another'),
        isTrue,
      );
      expect(
        notifier.platformAlreadyExists('https://youtube.com/@test'),
        isFalse,
      );
    });

    test('getPlatformKey returns correct platform using utils', () {
      final notifier = getNotifier();
      expect(notifier.getPlatformKey('https://youtube.com/@test'), 'youtube');
      expect(notifier.getPlatformKey('https://unknown.com'), 'website');
    });
  });
}
