import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/following_provider.dart';
import '../widgets/following_user_tile.dart';

const double _appBarFontSize = 26;
const double _errorTitleFontSize = 20;
const double _emptyTitleFontSize = 22;
const double _sectionTitleFontSize = 18;

class FollowingScreen extends ConsumerStatefulWidget {
  const FollowingScreen({super.key});

  @override
  ConsumerState<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends ConsumerState<FollowingScreen> {
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
      ref.read(followingProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final FollowingState state = ref.watch(followingProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
  backgroundColor: AppColors.background,
  elevation: 0,
  titleSpacing: 0,
  title: Text(
    'Following',
    style: AppTextStyles.headlineMedium.copyWith(
      fontSize: _appBarFontSize,
      fontWeight: FontWeight.w700,
    ),
  ),
  actions: [
    IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: () {
        ref.read(followingProvider.notifier).refresh();
      },
    ),
  ],
),
      body: RefreshIndicator(
        onRefresh: () => ref.read(followingProvider.notifier).refresh(),
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
                          'Failed to load following users.',
                          style: AppTextStyles.headlineMedium.copyWith(
                            fontSize: _errorTitleFontSize,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppDimensions.paddingSm),
                        TextButton(
                          onPressed: () {
                            ref.read(followingProvider.notifier).loadInitial();
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingLg,
                    ),
                    child: Column(
                      children: <Widget>[
                        const Icon(
                          Icons.people_outline_rounded,
                          size: 72,
                          color: AppColors.textMuted,
                        ),
                        SizedBox(height: AppDimensions.paddingMd),
                        Text(
                          'You are not following anyone yet.',
                          style: AppTextStyles.headlineMedium.copyWith(
                            fontSize: _emptyTitleFontSize,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppDimensions.paddingSm),
                        Text(
                          'Discover artists and creators to build your community.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppDimensions.paddingLg),
                        ElevatedButton(
                          onPressed: () {
                            context.go(RoutePaths.discover);
                          },
                          child: const Text('Discover people →'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            final int itemCount =
                1 + state.users.length + (state.isLoadingMore ? 1 : 0);

            return ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: AppDimensions.paddingMd),
              itemCount: itemCount,
              separatorBuilder: (_, __) => const SizedBox.shrink(),
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingMd,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(AppDimensions.paddingMd),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusXl),
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.onPrimary,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.people_outline,
                              color: AppColors.onPrimary,
                            ),
                          ),
                          SizedBox(width: AppDimensions.paddingMd),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'People who follow you back',
                                  style: AppTextStyles.headlineMedium.copyWith(
                                    fontSize: _sectionTitleFontSize,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'See your true friends',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.onPrimary,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final int userIndex = index - 1;

                if (userIndex >= state.users.length) {
                  return Padding(
                    padding: EdgeInsets.all(AppDimensions.paddingMd),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final followingUser = state.users[userIndex];

                return Column(
                  children: <Widget>[
                    FollowingUserTile(
                      user: followingUser,
                      onTap: () {
                        context.go(RoutePaths.profile);
                      },
                    ),
                    const Divider(
                      height: 1,
                      color: AppColors.divider,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}