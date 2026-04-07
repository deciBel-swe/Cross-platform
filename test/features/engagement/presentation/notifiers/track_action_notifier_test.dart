import 'package:decibel/core/errors/exceptions.dart';
import 'package:decibel/features/engagement/domain/models/track_action_data.dart';
import 'package:decibel/features/engagement/domain/repositories/track_social_repository.dart';
import 'package:decibel/features/engagement/presentation/providers/track_social_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTrackSocialRepository extends Mock
    implements ITrackSocialRepository {}

void main() {
  late MockTrackSocialRepository mockRepository;

  setUp(() {
    mockRepository = MockTrackSocialRepository();

    when(() => mockRepository.likeTrack(any())).thenAnswer((_) async {});
    when(() => mockRepository.unlikeTrack(any())).thenAnswer((_) async {});
    when(() => mockRepository.repostTrack(any())).thenAnswer((_) async {});
    when(() => mockRepository.unrepostTrack(any())).thenAnswer((_) async {});
  });

  test('mergeTrack initializes and updates social state', () {
    final container = ProviderContainer(
      overrides: [
        trackSocialRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(trackSocialProvider.notifier);

    notifier.mergeTrack(7, isLiked: true, likeCount: 3);
    var state = container.read(trackSocialProvider);
    expect(state.trackStates['7']?.isLiked, isTrue);
    expect(state.trackStates['7']?.likeCount, 3);

    notifier.mergeTrack(7, isReposted: true, repostCount: 2);
    state = container.read(trackSocialProvider);
    expect(state.trackStates['7']?.isLiked, isTrue);
    expect(state.trackStates['7']?.isReposted, isTrue);
    expect(state.trackStates['7']?.repostCount, 2);
  });

  test('toggleAction(like) updates state and calls repository', () async {
    final container = ProviderContainer(
      overrides: [
        trackSocialRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(trackSocialProvider.notifier);

    await notifier.toggleAction(
      10,
      SocialActionType.like,
      initialLikeCount: 4,
      initialIsLiked: false,
    );

    final state = container.read(trackSocialProvider);
    expect(state.trackStates['10']?.isLiked, isTrue);
    expect(state.trackStates['10']?.likeCount, 5);
    expect(state.loadingKeys.contains('like_10'), isFalse);
    verify(() => mockRepository.likeTrack(10)).called(1);
  });

  test('toggleAction rolls back when repository throws AppException', () async {
    when(
      () => mockRepository.likeTrack(any()),
    ).thenThrow(const ServerException('failed'));

    final container = ProviderContainer(
      overrides: [
        trackSocialRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(trackSocialProvider.notifier);

    await notifier.toggleAction(
      11,
      SocialActionType.like,
      initialLikeCount: 6,
      initialIsLiked: false,
    );

    final state = container.read(trackSocialProvider);
    expect(state.trackStates['11']?.isLiked, isFalse);
    expect(state.trackStates['11']?.likeCount, 6);
    expect(state.loadingKeys.contains('like_11'), isFalse);
    verify(() => mockRepository.likeTrack(11)).called(1);
  });
}
