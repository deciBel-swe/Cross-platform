import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:decibel/features/auth/domain/entities/auth_state.dart';
import 'package:decibel/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:decibel/core/storage/secure_storage_service.dart';
import 'package:decibel/features/auth/presentation/providers/auth_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:decibel/features/auth/domain/entities/auth_user.dart';
import 'package:decibel/core/errors/failures.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

// A Listener to verify state changes
class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {
  setUpAll(() {
    registerFallbackValue(const AsyncLoading<AuthState>());
  });

  late ProviderContainer container;
  late MockAuthRepository mockAuthRepository;
  late MockSecureStorageService mockSecureStorageService;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockSecureStorageService = MockSecureStorageService();

    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
        secureStorageServiceProvider.overrideWithValue(
          mockSecureStorageService,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthNotifier build()', () {
    const tUser = AuthUser(id: 1, username: 'test_user', tier: UserTier.free);

    test(
      'should initialize as AuthUnauthenticated when token is expired',
      () async {
        // Arrange
        when(
          () => mockSecureStorageService.isAccessTokenExpired(),
        ).thenAnswer((_) async => true);

        final state = await container.read(authStateProvider.future);

        // Assert
        expect(state, isA<AuthUnauthenticated>());
      },
    );

    test(
      'should initialize as AuthUnauthenticated when token is not expired but getCurrentUser fails',
      () async {
        // Arrange
        when(
          () => mockSecureStorageService.isAccessTokenExpired(),
        ).thenAnswer((_) async => false);
        when(
          () => mockAuthRepository.getCurrentUser(),
        ).thenAnswer((_) async => const Right(null));

        final state = await container.read(authStateProvider.future);

        // Assert
        expect(state, isA<AuthUnauthenticated>());
      },
    );

    test(
      'should initialize as AuthAuthenticated when token is valid and user is returned',
      () async {
        // Arrange
        when(
          () => mockSecureStorageService.isAccessTokenExpired(),
        ).thenAnswer((_) async => false);
        when(
          () => mockAuthRepository.getCurrentUser(),
        ).thenAnswer((_) async => const Right(tUser));

        final state = await container.read(authStateProvider.future);

        // Assert
        expect(state, isA<AuthAuthenticated>());
        expect((state as AuthAuthenticated).user.id, 1);
      },
    );
  });

  group('AuthNotifier loginWithGoogle()', () {
    const tUser = AuthUser(id: 1, username: 'test_user', tier: UserTier.free);

    test(
      'should emit [AsyncLoading, AsyncData(AuthAuthenticated)] on successful login',
      () async {
        // Arrange
        when(
          () => mockSecureStorageService.isAccessTokenExpired(),
        ).thenAnswer((_) async => true); // Initial state
        when(
          () => mockAuthRepository.loginWithGoogle(),
        ).thenAnswer((_) async => const Right(tUser));

        final listener = Listener<AsyncValue<AuthState>>();
        container.listen(
          authStateProvider,
          listener.call,
          fireImmediately: true,
        );

        // Wait for initial build
        await container.read(authStateProvider.future);

        // Act
        await container.read(authStateProvider.notifier).loginWithGoogle();

        // Assert
        verifyInOrder([
          // Initialization
          () => listener(any(), any(that: isA<AsyncLoading<AuthState>>())),
          () => listener(any(), any(that: isA<AsyncData<AuthState>>())),

          // loginWithGoogle called -> Loading
          () => listener(any(), any(that: isA<AsyncLoading<AuthState>>())),

          // loginWithGoogle successful -> Authenticated
          () => listener(any(), any(that: isA<AsyncData<AuthState>>())),
        ]);
      },
    );

    test('should emit [AsyncLoading, AsyncError] on failed login', () async {
      // Arrange
      when(
        () => mockSecureStorageService.isAccessTokenExpired(),
      ).thenAnswer((_) async => true); // Initial state
      when(
        () => mockAuthRepository.loginWithGoogle(),
      ).thenAnswer((_) async => const Left(AuthFailure('Login failed')));

      final listener = Listener<AsyncValue<AuthState>>();
      container.listen(authStateProvider, listener.call, fireImmediately: true);

      // Wait for initial build
      await container.read(authStateProvider.future);

      // Act
      await container.read(authStateProvider.notifier).loginWithGoogle();

      // Assert
      verifyInOrder([
        // Initialization
        () => listener(any(), any(that: isA<AsyncLoading<AuthState>>())),
        () => listener(any(), any(that: isA<AsyncData<AuthState>>())),

        // loginWithGoogle called -> Loading
        () => listener(any(), any(that: isA<AsyncLoading<AuthState>>())),

        // Error caught -> Error state
        () => listener(any(), any(that: isA<AsyncError<AuthState>>())),
      ]);
    });
  });

  group('AuthNotifier logout()', () {
    test(
      'should call secureStorage.clearAll and emit AuthUnauthenticated',
      () async {
        // Arrange
        when(
          () => mockSecureStorageService.isAccessTokenExpired(),
        ).thenAnswer((_) async => true); // Initial state
        when(
          () => mockSecureStorageService.clearAll(),
        ).thenAnswer((_) async => {});

        // Wait for initial build
        await container.read(authStateProvider.future);

        // Act
        await container.read(authStateProvider.notifier).logout();

        // Assert
        verify(() => mockSecureStorageService.clearAll()).called(1);
        final state = await container.read(authStateProvider.future);
        expect(state, isA<AuthUnauthenticated>());
      },
    );
  });
}
