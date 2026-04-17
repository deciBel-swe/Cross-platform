// lib/features/upgrade/domain/entities/subscription_status.dart

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/subscription_tier_helper.dart';

part 'subscription_status.freezed.dart';

/// Domain entity representing the user's subscription state.
@freezed
class SubscriptionStatus with _$SubscriptionStatus {
  const SubscriptionStatus._();

  const factory SubscriptionStatus({
    required String status,
    required String plan,
    required DateTime? currentPeriodEnd,
    required bool cancelAtPeriodEnd,
  }) = _SubscriptionStatus;

  // Derived helpers

  String get normalizedStatus => status.trim().toUpperCase();

  bool get isActive =>
      normalizedStatus == 'ACTIVE' || normalizedStatus == 'TRIALING';

  bool get isPro => SubscriptionTierHelper.isPremium(plan);
}
