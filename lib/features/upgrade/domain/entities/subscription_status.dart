import '../../../../core/utils/subscription_tier_helper.dart';

class SubscriptionStatus {
  const SubscriptionStatus({
    required this.status,
    required this.plan,
    required this.currentPeriodEnd,
    required this.cancelAtPeriodEnd,
  });

  final String status;
  final String plan;
  final DateTime? currentPeriodEnd;
  final bool cancelAtPeriodEnd;

  String get normalizedStatus => status.trim().toUpperCase();

  bool get isActive {
    return normalizedStatus == 'ACTIVE' || normalizedStatus == 'TRIALING';
  }

  bool get isPro => SubscriptionTierHelper.isPremium(plan);
}
