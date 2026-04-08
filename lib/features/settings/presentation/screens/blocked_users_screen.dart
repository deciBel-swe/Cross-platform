import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../library_profile/domain/entities/blocked_user_summary.dart';
import '../../../library_profile/presentation/providers/block_provider.dart';
import '../providers/blocked_users_provider.dart';

class BlockedUsersScreen extends ConsumerStatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  ConsumerState<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends ConsumerState<BlockedUsersScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    Future.microtask(() async {
      await ref.read(blockedUsersListProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;
    final threshold = position.maxScrollExtent * 0.8;

    if (position.pixels >= threshold) {
      ref.read(blockedUsersListProvider.notifier).loadMore();
    }
  }

  Future<void> _showUnblockConfirmation(
    BuildContext context,
    int userId,
    String username,
  ) async {
    final bool? confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Unblock user?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Do you want to unblock $username?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(sheetContext, false),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(sheetContext, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Unblock'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final success = await ref
        .read(blockedUsersListProvider.notifier)
        .unblockUser(userId: userId);

    if (!mounted) {
      return;
    }

    if (success) {
      ref.read(blockedUsersProvider.notifier).markUnblockedLocally(userId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$username unblocked successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to unblock user.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(blockedUsersListProvider);

    ref.listen(blockedUsersListProvider, (previous, next) {
      final summaries = next.users
          .map(
            (user) => BlockedUserSummary(
              id: user.id,
              username: user.username,
              avatarUrl: user.avatarUrl,
            ),
          )
          .toList();

      ref.read(blockedUsersProvider.notifier).syncFromBackend(summaries);
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Blocked users'),
        backgroundColor: AppColors.background,
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(blockedUsersListProvider.notifier).refresh(),
        child: Builder(
          builder: (context) {
            if (state.isLoading && state.users.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.hasError && state.users.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 220),
                  Center(
                    child: Text(
                      'Failed to load blocked users.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              );
            }

            if (state.users.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 220),
                  Center(
                    child: Text(
                      "You haven't blocked anyone.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              );
            }

            final itemCount =
                state.users.length + (state.isLoadingMore ? 1 : 0);

            return ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: itemCount,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index >= state.users.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final user = state.users[index];

                return InkWell(
                  onTap: () {
                    context.push(RoutePaths.publicProfile(user.id));
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white12,
                          backgroundImage: (user.avatarUrl != null &&
                                  user.avatarUrl!.trim().isNotEmpty)
                              ? NetworkImage(user.avatarUrl!)
                              : null,
                          child: (user.avatarUrl == null ||
                                  user.avatarUrl!.trim().isEmpty)
                              ? const Icon(Icons.person, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            user.username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => _showUnblockConfirmation(
                            context,
                            user.id,
                            user.username,
                          ),
                          child: const Text(
                            'Unblock',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}