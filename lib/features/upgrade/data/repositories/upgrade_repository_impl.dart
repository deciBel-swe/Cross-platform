import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/subscription_status.dart';
import '../../domain/repositories/upgrade_repository.dart';
import '../datasources/upgrade_remote_datasource.dart';

class UpgradeRepositoryImpl implements UpgradeRepository {
  const UpgradeRepositoryImpl(this._remoteDatasource);

  final IUpgradeRemoteDatasource _remoteDatasource;

  @override
  Future<Either<Failure, SubscriptionStatus>> getSubscriptionStatus() async {
    try {
      final model = await _remoteDatasource.getSubscriptionStatus();
      return Right(model.toEntity());
    } on AuthException catch (error) {
      return Left(AuthFailure(error.message));
    } on NetworkException catch (error) {
      return Left(ServerFailure(error.message));
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, SubscriptionStatus>> cancelSubscription() async {
    try {
      final model = await _remoteDatasource.cancelSubscription();
      return Right(model.toEntity());
    } on AuthException catch (error) {
      return Left(AuthFailure(error.message));
    } on NetworkException catch (error) {
      return Left(ServerFailure(error.message));
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, SubscriptionStatus>> renewSubscription() async {
    try {
      final model = await _remoteDatasource.renewSubscription();
      return Right(model.toEntity());
    } on AuthException catch (error) {
      return Left(AuthFailure(error.message));
    } on NetworkException catch (error) {
      return Left(ServerFailure(error.message));
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createCheckout({required String tier}) async {
    try {
      final response = await _remoteDatasource.createCheckout(tier: tier);
      return Right(response.checkoutUrl);
    } on AuthException catch (error) {
      return Left(AuthFailure(error.message));
    } on NetworkException catch (error) {
      return Left(ServerFailure(error.message));
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
