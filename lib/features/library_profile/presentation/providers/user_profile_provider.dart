import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_profile.dart';
import '../notifiers/user_profile_notifier.dart';

final userProfileProvider =
    AsyncNotifierProvider.autoDispose<
      UserProfileNotifier,
      Either<Failure, UserProfile>
    >(UserProfileNotifier.new);
