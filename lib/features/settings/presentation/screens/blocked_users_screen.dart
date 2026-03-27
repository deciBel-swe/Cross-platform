import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/blocked_user.dart';
import '../providers/blocked_users_provider.dart';
import '../widgets/blocked_user_tile.dart';

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

    final ScrollPosition position = _scrollController.position;
    final double threshold = position.maxScrollExtent * 0.8;

    if (position.pixels >= threshold) {
      ref.read(blockedUsersProvider.notifier).loadMore();
    }
  }

  Future<void> _showUnblockConfirmation(BuildContext context, BlockedUser user) async {
    final bool? confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingLg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Unblock ${user.username}?',
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppDimensions.paddingSm),
                Text(
                  'They will be able to interact with you again.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppDimensions.paddingLg),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Unblock'),
                  ),
                ),
                SizedBox(height: AppDimensions.paddingSm),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    await ref.read(blockedUsersProvider.notifier).unblockUser(userId: user.id);
  }

  @override
  Widget build(BuildContext context) {
    final BlockedUsersState state = ref.watch(blockedUsersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Blocked users',
          style: AppTextStyles.headlineMedium.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(blockedUsersProvider.notifier).refresh(),
        child: Builder(
          builder: (BuildContext context) {
            if (state.isLoading && state.users.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.hasError && state.users.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.22),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingLg,
                    ),
                    child: Column(
                      children: <Widget>[
                        const Icon(
                          Icons.wifi_off_rounded,
                          color: AppColors.textMuted,
                          size: 54,
                        ),
                        SizedBox(height: AppDimensions.paddingMd),
                        Text(
                          'Failed to load blocked users.',
                          style: AppTextStyles.headlineMedium.copyWith(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppDimensions.paddingSm),
                        TextButton(
                          onPressed: () {
                            ref.read(blockedUsersProvider.notifier).loadInitial();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            if (state.users.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.22),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingLg,
                    ),
                    child: Column(
                      children: <Widget>[
                        const Icon(
                          Icons.block,
                          size: 72,
                          color: AppColors.textMuted,
                        ),
                        SizedBox(height: AppDimensions.paddingMd),
                        Text(
                          "You haven't blocked anyone.",
                          style: AppTextStyles.headlineMedium.copyWith(
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            final int itemCount =
                state.users.length + (state.isLoadingMore ? 1 : 0);

            return ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: itemCount,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                color: AppColors.divider,
              ),
              itemBuilder: (BuildContext context, int index) {
                if (index >= state.users.length) {
                  return Padding(
                    padding: EdgeInsets.all(AppDimensions.paddingMd),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final BlockedUser user = state.users[index];

                return BlockedUserTile(
                  user: user,
                  onUnblockTap: () => _showUnblockConfirmation(context, user),
                );
              },
            );
          },
        ),
      ),
    );
  }
}