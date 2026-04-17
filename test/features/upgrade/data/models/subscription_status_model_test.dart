import 'package:decibel/features/upgrade/data/models/subscription_status_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SubscriptionStatusModel.fromJson', () {
    test('parses currentPeriodEnd epoch seconds', () {
      final model = SubscriptionStatusModel.fromJson({
        'status': 'ACTIVE',
        'plan': 'ARTIST_PRO',
        'currentPeriodEnd': 1735689600,
        'cancelAtPeriodEnd': false,
      });

      expect(model.currentPeriodEnd, isNotNull);
      expect(model.currentPeriodEnd!.millisecondsSinceEpoch, 1735689600000);
    });

    test('parses currentPeriodEnd epoch milliseconds', () {
      final model = SubscriptionStatusModel.fromJson({
        'status': 'ACTIVE',
        'plan': 'PRO',
        'currentPeriodEnd': 1735689600000,
        'cancelAtPeriodEnd': true,
      });

      expect(model.currentPeriodEnd, isNotNull);
      expect(model.currentPeriodEnd!.millisecondsSinceEpoch, 1735689600000);
      expect(model.cancelAtPeriodEnd, isTrue);
    });

    test('handles invalid epoch values safely', () {
      final model = SubscriptionStatusModel.fromJson({
        'status': 'INACTIVE',
        'plan': 'FREE',
        'currentPeriodEnd': 'bad-value',
        'cancelAtPeriodEnd': false,
      });

      expect(model.currentPeriodEnd, isNull);
    });
  });
}
