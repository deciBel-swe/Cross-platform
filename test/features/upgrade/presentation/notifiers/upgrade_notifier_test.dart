import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/upgrade/domain/entities/subscription_status.dart';
import 'package:decibel/features/upgrade/domain/repositories/upgrade_repository.dart';
import 'package:decibel/features/upgrade/presentation/providers/upgrade_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUpgradeRepository extends Mock implements UpgradeRepository {}

void main() {
  late ProviderContainer container;
  late MockUpgradeRepository mockUpgradeRepository;

  const activeSubscription = SubscriptionStatus(
    status: 'ACTIVE',
    plan: 'ARTIST_PRO',
    currentPeriodEnd: null,
    cancelAtPeriodEnd: false,
  );

  const canceledSubscription = SubscriptionStatus(
    status: 'ACTIVE',
    plan: 'ARTIST_PRO',
    currentPeriodEnd: null,
    cancelAtPeriodEnd: true,
  );

  setUp(() {
    mockUpgradeRepository = MockUpgradeRepository();

    container = ProviderContainer(
      overrides: [
        upgradeRepositoryProvider.overrideWithValue(mockUpgradeRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('build loads subscription status', () async {
    when(
      () => mockUpgradeRepository.getSubscriptionStatus(),
    ).thenAnswer((_) async => const Right(activeSubscription));

    final state = await container.read(upgradeNotifierProvider.future);

    expect(state.subscription.plan, 'ARTIST_PRO');
    verify(() => mockUpgradeRepository.getSubscriptionStatus()).called(1);
  });

  test('startCheckout calls checkout endpoint and returns URL', () async {
    when(
      () => mockUpgradeRepository.getSubscriptionStatus(),
    ).thenAnswer((_) async => const Right(activeSubscription));
    when(
      () => mockUpgradeRepository.createCheckout(tier: 'ARTIST_PRO'),
    ).thenAnswer((_) async => const Right('https://stripe.test/checkout'));

    await container.read(upgradeNotifierProvider.future);

    final result = await container
        .read(upgradeNotifierProvider.notifier)
        .startCheckout();

    expect(result.isRight(), isTrue);
    verify(
      () => mockUpgradeRepository.createCheckout(tier: 'ARTIST_PRO'),
    ).called(1);
  });

  test('cancelAtPeriodEnd updates state with canceled subscription', () async {
    when(
      () => mockUpgradeRepository.getSubscriptionStatus(),
    ).thenAnswer((_) async => const Right(activeSubscription));
    when(
      () => mockUpgradeRepository.cancelSubscription(),
    ).thenAnswer((_) async => const Right(canceledSubscription));

    await container.read(upgradeNotifierProvider.future);

    final result = await container
        .read(upgradeNotifierProvider.notifier)
        .cancelAtPeriodEnd();

    expect(result.isRight(), isTrue);
    final state = container.read(upgradeNotifierProvider).valueOrNull;
    expect(state, isNotNull);
    expect(state!.subscription.cancelAtPeriodEnd, isTrue);
  });

  test('renewSubscription propagates failures', () async {
    when(
      () => mockUpgradeRepository.getSubscriptionStatus(),
    ).thenAnswer((_) async => const Right(canceledSubscription));
    when(
      () => mockUpgradeRepository.renewSubscription(),
    ).thenAnswer((_) async => const Left(ServerFailure('renew failed')));

    await container.read(upgradeNotifierProvider.future);

    final result = await container
        .read(upgradeNotifierProvider.notifier)
        .renewSubscription();

    expect(result.isLeft(), isTrue);
  });
}
