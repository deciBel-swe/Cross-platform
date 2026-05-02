import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/repositories/i_messaging_repository.dart';
import '../notifiers/conversations_notifier.dart';
import '../state/conversations_state.dart';

/// Bridge provider that exposes the [IMessagingRepository] from GetIt.
///
/// This allows Notifiers to access the domain layer while keeping the
/// DI logic centralized in the core module.
final messagingRepositoryProvider = Provider<IMessagingRepository>((ref) {
  return getIt<IMessagingRepository>();
});

/// Global provider for the user's direct messaging inbox.
///
/// Uses [AsyncNotifierProvider] to handle the asynchronous initialization
/// and paginated state of the conversation list.
final conversationsProvider =
    AsyncNotifierProvider<ConversationsNotifier, ConversationsState>(
      ConversationsNotifier.new,
    );
