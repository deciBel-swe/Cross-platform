import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/repositories/i_upload_repository.dart';

final uploadRepositoryProvider = Provider<IUploadRepository>((ref) {
  return getIt<IUploadRepository>();
});
