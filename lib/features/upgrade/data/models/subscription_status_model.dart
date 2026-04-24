// lib/features/upgrade/data/models/subscription_status_model.dart

import '../../domain/entities/subscription_status.dart';

class SubscriptionStatusModel {
  const SubscriptionStatusModel({
    required this.status,
    required this.plan,
    required this.currentPeriodEnd,
    required this.cancelAtPeriodEnd,
  });

  factory SubscriptionStatusModel.fromJson(Map<String, dynamic> json) {
    final periodValue = json['currentPeriodEnd'] ?? json['current_period_end'];
    final cancelValue =
        json['cancelAtPeriodEnd'] ?? json['cancel_at_period_end'];
    return SubscriptionStatusModel(
      status: (json['status'] ?? '').toString(),
      plan: (json['plan'] ?? '').toString(),
      currentPeriodEnd: _parseDateTime(periodValue),
      cancelAtPeriodEnd: _asBool(cancelValue),
    );
  }

  final String status;
  final String plan;
  final DateTime? currentPeriodEnd;
  final bool cancelAtPeriodEnd;

  SubscriptionStatus toEntity() => SubscriptionStatus(
    status: status,
    plan: plan,
    currentPeriodEnd: currentPeriodEnd,
    cancelAtPeriodEnd: cancelAtPeriodEnd,
  );

  static DateTime? _parseDateTime(Object? value) {
    if (value == null) return null;
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed;
    }
    final numeric = switch (value) {
      int intValue => intValue,
      double doubleValue => doubleValue.toInt(),
      String stringValue => int.tryParse(stringValue),
      _ => null,
    };
    if (numeric == null || numeric == 0) return null;
    final isSeconds = numeric < 9999999999;
    return DateTime.fromMillisecondsSinceEpoch(
      isSeconds ? numeric * 1000 : numeric,
    );
  }

  static bool _asBool(Object? value) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    if (value is num) return value != 0;
    return false;
  }
}
