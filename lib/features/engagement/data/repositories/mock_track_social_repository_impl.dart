import 'package:injectable/injectable.dart';

import '../../domain/repositories/track_social_repository.dart';

@Environment('mock')
@LazySingleton(as: ITrackSocialRepository)
class MockTrackSocialRepository implements ITrackSocialRepository {
  const MockTrackSocialRepository();

  static const Duration _mockDelay = Duration(milliseconds: 250);

  @override
  Future<void> likeTrack(int trackId) async {
    await Future<void>.delayed(_mockDelay);
  }

  @override
  Future<void> unlikeTrack(int trackId) async {
    await Future<void>.delayed(_mockDelay);
  }

  @override
  Future<void> repostTrack(int trackId) async {
    await Future<void>.delayed(_mockDelay);
  }

  @override
  Future<void> unrepostTrack(int trackId) async {
    await Future<void>.delayed(_mockDelay);
  }
}
