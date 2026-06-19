import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/repositories/i_offline_repository.dart';
import '../notifiers/collection_download_notifier.dart';

/// A family provider that creates a separate [CollectionDownloadNotifier] for
/// each collection ID (playlist or station). This allows independent progress
/// tracking per collection on the same screen.
final collectionDownloadProvider = StateNotifierProvider.autoDispose
    .family<CollectionDownloadNotifier, CollectionDownloadState, int>((
  ref,
  collectionId,
) {
  return CollectionDownloadNotifier(getIt<IOfflineRepository>());
});
