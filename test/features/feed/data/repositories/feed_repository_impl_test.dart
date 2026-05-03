import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/exceptions.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/feed/data/datasources/feed_data_datasource.dart';
import 'package:decibel/features/feed/data/models/paginated_feed_model.dart';
import 'package:decibel/features/feed/data/repositories/feed_repository_impl.dart';
import 'package:decibel/features/feed/domain/entities/paginated_feed.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFeedRemoteDatasource extends Mock implements IFeedRemoteDatasource {}

void main() {
  late MockFeedRemoteDatasource mockDataSource;
  late FeedRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockFeedRemoteDatasource();
    repository = FeedRepositoryImpl(mockDataSource);
  });

  const tPaginatedFeedModel = PaginatedFeedModel(
    content: [],
    pageNumber: 0,
    pageSize: 20,
    totalElements: 0,
    totalPages: 0,
    isLast: true,
  );

  group('getFeed', () {
    test('should return PaginatedFeed when the call is successful', () async {
      when(() => mockDataSource.getFeed(page: 0, size: 20))
          .thenAnswer((_) async => tPaginatedFeedModel);

      final result = await repository.getFeed(page: 0, size: 20);

      expect(result.isRight(), true);
      verify(() => mockDataSource.getFeed(page: 0, size: 20)).called(1);
    });

    test('should return NetworkFailure when repository throws NetworkException', () async {
      when(() => mockDataSource.getFeed(page: 0, size: 20))
          .thenThrow(const NetworkException('No connection'));

      final result = await repository.getFeed(page: 0, size: 20);

      expect(result, equals(const Left<Failure, PaginatedFeed>(NetworkFailure('No connection'))));
    });

    test('should return ServerFailure when repository throws ServerException', () async {
      when(() => mockDataSource.getFeed(page: 0, size: 20))
          .thenThrow(const ServerException('Server error'));

      final result = await repository.getFeed(page: 0, size: 20);

      expect(result, equals(const Left<Failure, PaginatedFeed>(ServerFailure('Server error'))));
    });

    test('should return ServerFailure for any other exception', () async {
      when(() => mockDataSource.getFeed(page: 0, size: 20))
          .thenThrow(Exception('unknown'));

      final result = await repository.getFeed(page: 0, size: 20);

      expect(result, equals(const Left<Failure, PaginatedFeed>(ServerFailure('Exception: unknown'))));
    });
  });

  group('getDiscoverFeed', () {
    test('should return PaginatedFeed when the call is successful', () async {
      when(() => mockDataSource.getDiscoverFeed(page: 0, size: 20))
          .thenAnswer((_) async => tPaginatedFeedModel);

      final result = await repository.getDiscoverFeed(page: 0, size: 20);

      expect(result.isRight(), true);
      verify(() => mockDataSource.getDiscoverFeed(page: 0, size: 20)).called(1);
    });

    test('should return NetworkFailure when repository throws NetworkException', () async {
      when(() => mockDataSource.getDiscoverFeed(page: 0, size: 20))
          .thenThrow(const NetworkException('No connection'));

      final result = await repository.getDiscoverFeed(page: 0, size: 20);

      expect(result, equals(const Left<Failure, PaginatedFeed>(NetworkFailure('No connection'))));
    });

    test('should return ServerFailure when repository throws ServerException', () async {
      when(() => mockDataSource.getDiscoverFeed(page: 0, size: 20))
          .thenThrow(const ServerException('Server error'));

      final result = await repository.getDiscoverFeed(page: 0, size: 20);

      expect(result, equals(const Left<Failure, PaginatedFeed>(ServerFailure('Server error'))));
    });
  });
}
