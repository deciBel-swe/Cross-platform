import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/messaging_providers.dart';
import '../widgets/conversation_tile.dart';
import '../widgets/inbox/inbox_app_bar.dart';
import '../widgets/inbox/inbox_empty_state.dart';
import '../widgets/inbox/inbox_loading_tile.dart';
import '../widgets/inbox/inbox_new_message_fab.dart';

/// Screen displaying the user's active direct message threads.
///
/// Features:
/// - Infinite scrolling list of historical conversations.
/// - Fully accessible interface with comprehensive screen reader semantics.
/// - Handles routing payloads directly to individual chat threads.
/// - Shows unread count bubble for conversations.
/// - Marks conversation as locally read when opened.
class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(conversationsProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final conversationsAsync = ref.watch(conversationsProvider);
    final authState = ref.watch(authStateProvider).valueOrNull;

    final currentUserId = authState is AuthAuthenticated
        ? authState.user.id
        : 1;

    final isDesktop = ResponsiveUtils.isDesktop(context);

    return Semantics(
      label: 'Direct messages inbox',
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: isDesktop ? null : const InboxAppBar(),
        floatingActionButton: const InboxNewMessageFab(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDesktop)
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingLg),
                child: Text(
                  'Direct Messages',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Expanded(
              child: conversationsAsync.when(
                data: (state) {
                  final visibleConversations = state.conversations
                      .where(
                        (conversation) =>
                            conversation.participants.contains(currentUserId),
                      )
                      .toList();

                  if (visibleConversations.isEmpty) {
                    return const InboxEmptyState();
                  }

                  return Scrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
                      primary: false,
                      itemCount:
                          visibleConversations.length + (state.isLast ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index >= visibleConversations.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final conversation = visibleConversations[index];

                        final otherUserId = conversation.participants.firstWhere(
                          (id) => id != currentUserId,
                          orElse: () => currentUserId,
                        );

                        final otherUserAsync = ref.watch(
                          messageUserProfileProvider(otherUserId),
                        );

                        return otherUserAsync.when(
                          data: (profile) {
                            final otherUsername =
                                (profile.displayName != null &&
                                    profile.displayName!.trim().isNotEmpty)
                                ? profile.displayName!
                                : profile.username;

                            return ConversationTile(
                              conversation: conversation,
                              currentUserId: currentUserId,
                              onTap: () {
                                context.push(
                                  '${RoutePaths.chat}/${conversation.id}',
                                  extra: otherUsername,
                                );
                              },
                            );
                          },
                          loading: () => const InboxLoadingTile(),
                          error: (error, _) => const SizedBox.shrink(),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text(
                    error.toString(),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
