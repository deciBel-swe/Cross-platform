import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/blocked_users_provider.dart';

class BlockedUsersScreen extends ConsumerStatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  ConsumerState<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends ConsumerState<BlockedUsersScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(blockedUsersProvider.notifier).fetchBlockedUsers();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent -
            AppConstants.coverPhotoHeight) {
      ref.read(blockedUsersProvider.notifier).fetchBlockedUsers();
    }
  }

  void _showUnblockConfirmation(
    BuildContext context,
    String userId,
    String username,
  ) {
    showModalBottomSheet<Widget>(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingLarge,
          vertical: AppConstants.spacingRegular,
        ),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.spacingExtraLarge),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Grabber Handle
              Container(
                width: AppConstants.appBarLeadingWidth,
                height: AppConstants.spacingTiny,
                decoration: BoxDecoration(
                  color: AppColors.onPrimary,
                  borderRadius: BorderRadius.circular(
                    AppConstants.spacingTiny / 2,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingExtraLarge),

              // 2. Title
              Text(
                "Unblock $username?",
                style: const TextStyle(
                  color: AppColors.onPrimary,
                  fontSize: AppConstants.fontSizeLarge,
                ),
              ),
              const SizedBox(height: AppConstants.spacingLarge),

              // 3. Side-by-Side Buttons
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.spacingRegular,
                        ),
                        backgroundColor: AppColors.divider,
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: AppConstants.spacingSmall + AppConstants.spacingTiny,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(blockedUsersProvider.notifier)
                            .unblockUser(int.parse(userId));
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errors,
                        foregroundColor: AppColors.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.spacingRegular,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.badgeBorderRadius,
                          ),
                        ),
                      ),
                      child: const Text(
                        "Unblock",
                        style: TextStyle(fontSize: AppConstants.fontSizeMedium),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingSmall),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(blockedUsersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Blocked Users")),
      body: state.users.isEmpty && !state.isLoading
          ? const Center(child: Text("You haven't blocked anyone."))
          : ListView.builder(
              controller: _scrollController,
              itemCount: state.users.length + (state.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.users.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final user = state.users[index];
                final isUnblocking = state.unblockingIds.contains(
                  user.id.toString(),
                );

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.avatarUrl != null
                        ? NetworkImage(user.avatarUrl!)
                        : null,
                    child: user.avatarUrl == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text(user.username),
                  trailing: isUnblocking
                      ? const SizedBox(
                          width: AppConstants.spacingLarge,
                          height: AppConstants.spacingLarge,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : TextButton(
                          onPressed: () => _showUnblockConfirmation(
                            context,
                            user.id.toString(),
                            user.username,
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                          ),
                          child: const Text("Unblock"),
                        ),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
