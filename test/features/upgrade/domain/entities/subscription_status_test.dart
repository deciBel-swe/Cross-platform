import 'package:decibel/features/upgrade/domain/entities/subscription_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SubscriptionStatus', () {
    test('does not treat active FREE status as a paid subscription', () {
      const subscription = SubscriptionStatus(
        status: 'ACTIVE',
        plan: 'FREE',
        currentPeriodEnd: null,
        cancelAtPeriodEnd: false,
      );

      expect(subscription.isActive, isTrue);
      expect(subscription.isPro, isFalse);
      expect(subscription.hasActivePaidSubscription, isFalse);
    });

    test('treats active premium plans as paid subscriptions', () {
      const subscription = SubscriptionStatus(
        status: 'ACTIVE',
        plan: 'ARTIST_PRO',
        currentPeriodEnd: null,
        cancelAtPeriodEnd: false,
      );

      expect(subscription.isActive, isTrue);
      expect(subscription.isPro, isTrue);
      expect(subscription.hasActivePaidSubscription, isTrue);
    });

    test('does not treat inactive premium plans as paid subscriptions', () {
      const subscription = SubscriptionStatus(
        status: 'INACTIVE',
        plan: 'ARTIST_PRO',
        currentPeriodEnd: null,
        cancelAtPeriodEnd: false,
      );

      expect(subscription.isActive, isFalse);
      expect(subscription.isPro, isTrue);
      expect(subscription.hasActivePaidSubscription, isFalse);
    });
  });
}
