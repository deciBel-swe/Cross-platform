import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/comment.dart';
import '../../domain/repositories/i_track_comments_repository.dart'
    show ITrackCommentsRepository;
import '../datasources/track_comments_remote_data_source.dart';
import '../models/post_comment_request_model.dart';
import '../models/post_comment_response_model.dart';

@Environment("prod")
@LazySingleton(as: ITrackCommentsRepository)
class TrackCommentsRepository implements ITrackCommentsRepository {
  TrackCommentsRepository(this._remoteDatasource);
  final TrackCommentsRemoteDataSource _remoteDatasource;
  @override
  Future<Either<Failure, Comment>> postComment({
    required int trackId,
    required String body,
    int? timestampSeconds,
  }) async {
    final req = PostCommentRequestModel(
      body: body,
      timeStampseconds: timestampSeconds,
    );
    try {
      final comment = await _remoteDatasource.postComment(
        trackId: trackId,
        request: req,
      );
      return Right(comment.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> getComments({required int trackId}) {
    // TODO: implement getComments
    throw UnimplementedError();
  }
}
