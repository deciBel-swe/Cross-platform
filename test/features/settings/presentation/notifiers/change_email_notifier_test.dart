import 'package:decibel/features/settings/presentation/providers/change_email_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../settings_test_helpers.dart';

void main() {
  group('ChangeEmailNotifier', () {
    test('changeEmail stores a success message from the repository', () async {
      final repository = FakeChangeEmailRepository()
        ..response = 'Verification sent';
      final container = ProviderContainer(
        overrides: [
          changeEmailRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(changeEmailProvider.notifier)
          .changeEmail('new@example.com');

      final state = container.read(changeEmailProvider);
      expect(repository.requestedEmails, ['new@example.com']);
      expect(state.hasSuccess, isTrue);
      expect(state.successMessage, 'Verification sent');
    });

    test(
      'changeEmail uses the default success message for empty API text',
      () async {
        final repository = FakeChangeEmailRepository()..response = '';
        final container = ProviderContainer(
          overrides: [
            changeEmailRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        await container
            .read(changeEmailProvider.notifier)
            .changeEmail('new@example.com');

        expect(
          container.read(changeEmailProvider).successMessage,
          'verification code sent please verify',
        );
      },
    );

    test(
      'changeEmail maps backend validation errors for the email field',
      () async {
        final repository = FakeChangeEmailRepository()
          ..error = DioException(
            requestOptions: RequestOptions(path: '/account/email'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: '/account/email'),
              data: const {'message': 'One or more fields are invalid.'},
            ),
          );
        final container = ProviderContainer(
          overrides: [
            changeEmailRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        await container
            .read(changeEmailProvider.notifier)
            .changeEmail('bad@example.com');

        expect(
          container.read(changeEmailProvider).errorMessage,
          'email field is invalid re-enter it',
        );
      },
    );

    test('reset returns the state to idle', () async {
      final repository = FakeChangeEmailRepository();
      final container = ProviderContainer(
        overrides: [
          changeEmailRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(changeEmailProvider.notifier)
          .changeEmail('new@example.com');
      container.read(changeEmailProvider.notifier).reset();

      expect(container.read(changeEmailProvider).hasSuccess, isFalse);
      expect(container.read(changeEmailProvider).hasError, isFalse);
    });
  });
}
