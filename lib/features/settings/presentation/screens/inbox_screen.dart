import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/messaging_providers.dart';

/// Screen displaying the user's active direct message threads.
///
/// Features:
/// - Infinite scrolling list of historical conversations.
/// - Fully accessible interface with comprehensive screen reader semantics.
/// - Handles routing payloads directly to individual chat threads.
/// - Clean empty state reflecting the Decibel design guidelines.
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

    return Semantics(
      label: 'Direct messages inbox',
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          title: Semantics(
            header: true,
            child: const Text(
              'Direct Messages',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('${RoutePaths.messages}/new'),
          backgroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(Icons.edit, color: Colors.black),
        ),
        body: conversationsAsync.when(
          data: (state) {
            if (state.conversations.isEmpty) {
              return Semantics(
                label: 'Your inbox is empty',
                child: const Center(
                  child: Text(
                    'No messages yet.',
                    style: TextStyle(color: Colors.white54, fontSize: 15),
                  ),
                ),
              );
            }

            return ListView.builder(
              controller: _scrollController,
              itemCount: state.conversations.length + (state.isLast ? 0 : 1),
              itemBuilder: (context, index) {
                if (index >= state.conversations.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final conversation = state.conversations[index];
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

                    final timeString = _formatTimeAgo(
                      conversation.lastTimestamp,
                    );

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.surface,
                        child: Text(
                          otherUsername.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        otherUsername,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        conversation.lastMessage.isEmpty
                            ? timeString
                            : '${conversation.lastMessage} · $timeString',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                      onTap: () {
                        context.push(
                          '${RoutePaths.chat}/${conversation.id}',
                          extra: otherUsername,
                        );
                      },
                    );
                  },
                  loading: () => const ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.surface,
                    ),
                    title: Text(
                      'Loading...',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Loading profile...',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                  ),
                  error: (_, _) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.surface,
                      child: Text(
                        otherUserId.toString()[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      'User $otherUserId',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      conversation.lastMessage.isEmpty
                          ? 'No messages yet'
                          : conversation.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                    onTap: () {
                      context.push(
                        '${RoutePaths.chat}/${conversation.id}',
                        extra: 'User $otherUserId',
                      );
                    },
                  ),
                );
              },
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
    );
  }
}

String _formatTimeAgo(DateTime date) {
  final now = DateTime.now();
  final safeDate = date.isAfter(now) ? now : date;
  final difference = now.difference(safeDate);

  if (difference.inDays > 0) return '${difference.inDays}d';
  if (difference.inHours > 0) return '${difference.inHours}h';
  if (difference.inMinutes > 0) return '${difference.inMinutes}m';
  return 'Now';
}
