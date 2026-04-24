import 'package:decibel/core/utils/subscription_tier_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SubscriptionTierHelper', () {
    test('returns false for FREE tier', () {
      expect(SubscriptionTierHelper.isPremium('FREE'), isFalse);
    });

    test('returns true for PRO tier', () {
      expect(SubscriptionTierHelper.isPremium('PRO'), isTrue);
    });

    test('returns true for ARTIST_PRO tier', () {
      expect(SubscriptionTierHelper.isPremium('ARTIST_PRO'), isTrue);
    });

    test('normalizes lowercase and spaces', () {
      expect(SubscriptionTierHelper.isPremium('  artist_pro  '), isTrue);
    });
  });
}
