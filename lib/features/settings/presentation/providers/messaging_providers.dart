import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../core/di/injection.dart';
import '../../../library_profile/domain/repositories/profile_repository.dart';
import '../../domain/repositories/i_messaging_repository.dart';
import '../notifiers/chat_screen_notifier.dart';
import '../notifiers/chat_notifier.dart';
import '../notifiers/conversations_notifier.dart';
import '../state/chat_state.dart';
import '../state/chat_screen_state.dart';
import '../state/conversations_state.dart';

/// Centralizes all Riverpod provider declarations for the messaging feature.
///
/// Features:
/// - Exposes the injected IMessagingRepository dependency to notifiers.
/// - Defines global provider bindings for inbox and chat thread states.

final messagingRepositoryProvider = Provider<IMessagingRepository>((ref) {
  return getIt<IMessagingRepository>();
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return getIt<ProfileRepository>();
});

final messageUserProfileProvider = FutureProvider.family((
  ref,
  int userId,
) async {
  final repository = ref.read(profileRepositoryProvider);
  final result = await repository.getPublicProfile(userId);
  return result.fold((failure) => throw failure, (profile) => profile);
});

final chatForegroundConversationIdProvider =
    StreamProvider.autoDispose<String?>((ref) {
      return FirebaseMessaging.onMessage.map((message) {
        final dataConversationId = message.data['conversationId'];
        return dataConversationId?.toString();
      });
    });

final conversationsProvider =
    AsyncNotifierProvider<ConversationsNotifier, ConversationsState>(
      ConversationsNotifier.new,
    );

final chatProvider =
    AsyncNotifierProvider.family<ChatNotifier, ChatState, String>(
      ChatNotifier.new,
    );

final chatScreenControllerProvider =
    NotifierProvider.family<ChatScreenNotifier, ChatScreenState, String>(
      ChatScreenNotifier.new,
    );
