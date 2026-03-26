import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/blocked_users_notfiers.dart';
import '../states/blocked_users_state.dart';

final blockedUsersProvider = NotifierProvider<BlockedUsersNotifier, BlockedUsersState>(() {
  return BlockedUsersNotifier();
});