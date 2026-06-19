import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/subscription_checkout_models.dart';
import '../models/subscription_status_model.dart';

abstract class IUpgradeRemoteDatasource {
  Future<SubscriptionStatusModel> getSubscriptionStatus();

  Future<SubscriptionStatusModel> cancelSubscription();

  Future<SubscriptionStatusModel> renewSubscription();

  Future<SubscriptionCheckoutResponse> createCheckout({required String tier});
}

class UpgradeRemoteDatasource implements IUpgradeRemoteDatasource {
  const UpgradeRemoteDatasource(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<SubscriptionStatusModel> getSubscriptionStatus() async {
    try {
      final response = await _dioClient.get<dynamic>(
        ApiConstants.subscriptionStatusEndpoint,
      );
      final payload = _extractPayload(response.data);
      return SubscriptionStatusModel.fromJson(payload);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return const SubscriptionStatusModel(
          status: 'INACTIVE',
          plan: 'FREE',
          currentPeriodEnd: null,
          cancelAtPeriodEnd: false,
        );
      }
      throw _toException(error);
    } catch (error) {
      throw ServerException('Failed to parse subscription status: $error');
    }
  }

  @override
  Future<SubscriptionStatusModel> cancelSubscription() async {
    try {
      await _dioClient.post<dynamic>(ApiConstants.subscriptionCancelEndpoint);
      return getSubscriptionStatus();
    } on DioException catch (error) {
      throw _toException(error);
    }
  }

  @override
  Future<SubscriptionStatusModel> renewSubscription() async {
    try {
      await _dioClient.post<dynamic>(ApiConstants.subscriptionRenewEndpoint);
      return getSubscriptionStatus();
    } on DioException catch (error) {
      throw _toException(error);
    }
  }

  @override
  Future<SubscriptionCheckoutResponse> createCheckout({
    required String tier,
  }) async {
    try {
      final request = SubscriptionCheckoutRequest(tier: tier);
      final response = await _dioClient.post<dynamic>(
        ApiConstants.subscriptionCheckoutEndpoint,
        data: request.toJson(),
      );
      final payload = _extractPayload(response.data);
      final checkout = SubscriptionCheckoutResponse.fromJson(payload);
      if (checkout.checkoutUrl.trim().isEmpty) {
        throw const ServerException('Checkout URL is missing in response.');
      }
      return checkout;
    } on DioException catch (error) {
      throw _toException(error);
    }
  }

  Map<String, dynamic> _extractPayload(Object? data) {
    if (data is! Map<String, dynamic>) {
      throw const ServerException('Unexpected response format.');
    }

    final nested = data['data'];
    if (nested is Map<String, dynamic>) {
      final subscription = nested['subscription'];
      if (subscription is Map<String, dynamic>) {
        return subscription;
      }
      return nested;
    }

    final subscription = data['subscription'];
    if (subscription is Map<String, dynamic>) {
      return subscription;
    }

    return data;
  }

  AppException _toException(DioException error) {
    final statusCode = error.response?.statusCode;

    if (statusCode == 401) {
      return const AuthException(
        'Authentication required. Please log in again.',
      );
    }

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        (error.type == DioExceptionType.unknown &&
            error.error is SocketException)) {
      return const NetworkException();
    }

    final responseData = error.response?.data;
    if (responseData is Map<String, dynamic>) {
      final message =
          responseData['message'] ?? responseData['error'] ?? error.message;
      return ServerException(message?.toString() ?? 'Unknown server error');
    }

    return ServerException(error.message ?? 'Unknown server error');
  }
}
