import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/profile_edit_notifier.dart';

final profileEditNotifierProvider =
    AsyncNotifierProvider<ProfileEditNotifier, void>(ProfileEditNotifier.new);
