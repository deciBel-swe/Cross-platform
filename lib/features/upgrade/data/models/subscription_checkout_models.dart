class SubscriptionCheckoutRequest {
  const SubscriptionCheckoutRequest({required this.tier});

  final String tier;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'tier': tier};
  }
}

class SubscriptionCheckoutResponse {
  const SubscriptionCheckoutResponse({required this.checkoutUrl});

  factory SubscriptionCheckoutResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionCheckoutResponse(
      checkoutUrl: (json['checkoutUrl'] ?? '').toString(),
    );
  }

  final String checkoutUrl;
}
