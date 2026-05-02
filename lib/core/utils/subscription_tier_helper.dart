class SubscriptionTierHelper {
  SubscriptionTierHelper._();

  static const Set<String> _premiumTiers = <String>{'PRO', 'ARTIST_PRO'};

  static String normalize(String? tier) {
    return (tier ?? '').trim().toUpperCase();
  }

  static bool isPremium(String? tier) {
    return _premiumTiers.contains(normalize(tier));
  }
}
