import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/subscription_status.dart';

abstract class UpgradeRepository {
  Future<Either<Failure, SubscriptionStatus>> getSubscriptionStatus();

  Future<Either<Failure, SubscriptionStatus>> cancelSubscription();

  Future<Either<Failure, SubscriptionStatus>> renewSubscription();

  Future<Either<Failure, String>> createCheckout({required String tier});
}
