import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/subscription_status.dart';
import '../providers/upgrade_providers.dart';

class UpgradeViewState {
  const UpgradeViewState({
    required this.subscription,
    this.isCheckoutInProgress = false,
    this.isCancelInProgress = false,
    this.isRenewInProgress = false,
  });

  final SubscriptionStatus subscription;
  final bool isCheckoutInProgress;
  final bool isCancelInProgress;
  final bool isRenewInProgress;

  bool get isAnyActionInProgress {
    return isCheckoutInProgress || isCancelInProgress || isRenewInProgress;
  }

  UpgradeViewState copyWith({
    SubscriptionStatus? subscription,
    bool? isCheckoutInProgress,
    bool? isCancelInProgress,
    bool? isRenewInProgress,
  }) {
    return UpgradeViewState(
      subscription: subscription ?? this.subscription,
      isCheckoutInProgress: isCheckoutInProgress ?? this.isCheckoutInProgress,
      isCancelInProgress: isCancelInProgress ?? this.isCancelInProgress,
      isRenewInProgress: isRenewInProgress ?? this.isRenewInProgress,
    );
  }
}

class UpgradeNotifier extends AutoDisposeAsyncNotifier<UpgradeViewState> {
  static const UpgradeViewState _fallbackViewState = UpgradeViewState(
    subscription: SubscriptionStatus(
      status: 'INACTIVE',
      plan: 'FREE',
      currentPeriodEnd: null,
      cancelAtPeriodEnd: false,
    ),
  );

  @override
  Future<UpgradeViewState> build() async {
    final result = await ref
        .read(upgradeRepositoryProvider)
        .getSubscriptionStatus();

    return result.fold(
      (failure) => throw Exception(failure.message),
      (subscription) => UpgradeViewState(subscription: subscription),
    );
  }

  Future<Either<Failure, String>> startCheckout({
    String tier = 'ARTIST_PRO',
  }) async {
    final current = state.valueOrNull ?? _fallbackViewState;

    state = AsyncData(current.copyWith(isCheckoutInProgress: true));

    final result = await ref
        .read(upgradeRepositoryProvider)
        .createCheckout(tier: tier);

    return result.fold(
      (failure) {
        state = AsyncData(current.copyWith(isCheckoutInProgress: false));
        return Left(failure);
      },
      (checkoutUrl) {
        state = AsyncData(current.copyWith(isCheckoutInProgress: false));
        return Right(checkoutUrl);
      },
    );
  }

  Future<Either<Failure, SubscriptionStatus>> cancelAtPeriodEnd() async {
    final current = state.valueOrNull ?? _fallbackViewState;

    state = AsyncData(current.copyWith(isCancelInProgress: true));

    final result = await ref
        .read(upgradeRepositoryProvider)
        .cancelSubscription();

    return result.fold(
      (failure) {
        state = AsyncData(current.copyWith(isCancelInProgress: false));
        return Left(failure);
      },
      (subscription) {
        state = AsyncData(
          current.copyWith(
            subscription: subscription,
            isCancelInProgress: false,
          ),
        );
        return Right(subscription);
      },
    );
  }

  Future<Either<Failure, SubscriptionStatus>> renewSubscription() async {
    final current = state.valueOrNull ?? _fallbackViewState;

    state = AsyncData(current.copyWith(isRenewInProgress: true));

    final result = await ref
        .read(upgradeRepositoryProvider)
        .renewSubscription();

    return result.fold(
      (failure) {
        state = AsyncData(current.copyWith(isRenewInProgress: false));
        return Left(failure);
      },
      (subscription) {
        state = AsyncData(
          current.copyWith(
            subscription: subscription,
            isRenewInProgress: false,
          ),
        );
        return Right(subscription);
      },
    );
  }

  Future<void> refreshStatus() async {
    final current = state.valueOrNull;
    final result = await ref
        .read(upgradeRepositoryProvider)
        .getSubscriptionStatus();

    result.fold(
      (failure) {
        if (current == null) {
          state = AsyncError(Exception(failure.message), StackTrace.current);
        }
      },
      (subscription) {
        if (current == null) {
          state = AsyncData(UpgradeViewState(subscription: subscription));
          return;
        }

        state = AsyncData(current.copyWith(subscription: subscription));
      },
    );
  }
}
