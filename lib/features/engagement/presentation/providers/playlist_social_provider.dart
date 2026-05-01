import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/models/playlist_social_data.dart';
import '../../domain/repositories/playlist_social_repository.dart';
import '../notifiers/playlist_social_notifier.dart';

final playlistSocialRepositoryProvider = Provider<IPlaylistSocialRepository>(
  (ref) => getIt<IPlaylistSocialRepository>(),
);

final playlistSocialProvider =
    AsyncNotifierProvider.family<PlaylistSocialNotifier, PlaylistSocialData, int>(
      PlaylistSocialNotifier.new,
    );
