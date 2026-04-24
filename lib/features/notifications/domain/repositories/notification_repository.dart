import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../data/models/activity_notification_model.dart';
import '../entities/activity_notification.dart';

abstract class INotificationRepository {
  Future<(Failure?, List<ActivityNotification>?)> getNotifications(
    int page,
    int size,
  );
  Future<(Failure?, int?)> getUnreadCount();
  Future<Failure?> markAllAsRead();
  Future<Failure?> registerDeviceToken(String fcmToken);
}

@Injectable(as: INotificationRepository)
class NotificationRepository implements INotificationRepository {
  NotificationRepository(this._remoteDataSource);

  final INotificationRemoteDataSource _remoteDataSource;

  @override
  Future<(Failure?, List<ActivityNotification>?)> getNotifications(
    int page,
    int size,
  ) async {
    try {
      final models = await _remoteDataSource.getNotifications(
        page: page,
        size: size,
      );
      final entities = models.map((m) => m.toEntity()).toList();
      return (null, entities);
    } on ServerException catch (e) {
      return (ServerFailure(e.message), null);
    } catch (e) {
      return (const ServerFailure('An unexpected error occurred'), null);
    }
  }

  @override
  Future<(Failure?, int?)> getUnreadCount() async {
    try {
      final count = await _remoteDataSource.getUnreadCount();
      return (null, count);
    } on ServerException catch (e) {
      return (ServerFailure(e.message), null);
    } catch (e) {
      return (const ServerFailure('An unexpected error occurred'), null);
    }
  }

  @override
  Future<Failure?> markAllAsRead() async {
    try {
      await _remoteDataSource.markAllAsRead();
      return null;
    } on ServerException catch (e) {
      return ServerFailure(e.message);
    } catch (e) {
      return const ServerFailure('An unexpected error occurred');
    }
  }

  @override
  Future<Failure?> registerDeviceToken(String fcmToken) async {
    try {
      await _remoteDataSource.registerDeviceToken(fcmToken);
      return null;
    } on ServerException catch (e) {
      return ServerFailure(e.message);
    } catch (e) {
      return const ServerFailure('An unexpected error occurred');
    }
  }
}
