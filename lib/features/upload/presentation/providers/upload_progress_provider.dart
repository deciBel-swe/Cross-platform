import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'upload_sessions_provider.dart';

final uploadProgressProvider = Provider.family<UploadSession?, int>((
  ref,
  int trackId,
) {
  return ref.watch(uploadSessionByTrackIdProvider(trackId));
});
