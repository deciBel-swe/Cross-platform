import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'upload_notifier.dart';

final uploadProgressProvider = StreamProvider.family<double, String>((ref, uploadId) {
  final repository = ref.watch(uploadRepositoryProvider);
  
  // Clean up the WebSocket when this provider is disposed
  ref.onDispose(() {
    repository.cancelProgressSubscription(uploadId);
  });

  return repository.watchUploadProgress(uploadId);
});