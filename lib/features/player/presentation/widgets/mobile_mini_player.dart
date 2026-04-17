import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/decibel_cached_image.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../engagement/presentation/providers/follow_state_provider.dart';
import '../../../engagement/presentation/widgets/like_button.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';

/// A persistent mini player (SoundCloud-style) for the mobile layout
class MobileMiniPlayer extends ConsumerStatefulWidget {
  const MobileMiniPlayer({super.key});

  @override
  ConsumerState<MobileMiniPlayer> createState() => _MobileMiniPlayerState();
}

class _MobileMiniPlayerState extends ConsumerState<MobileMiniPlayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _snapController;
  late Animation<double> _snapAnimation;
  double _dragOffset = 0.0;
  int _swipeDirection = 0;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _snapAnimation = _snapController.drive(Tween<double>(begin: 0, end: 0));
    _snapController.addListener(() {
      setState(() {
        _dragOffset = _snapAnimation.value;
      });
    });
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  void _snapBack() {
    _snapAnimation = _snapController.drive(
      Tween<double>(begin: _dragOffset, end: 0),
    );
    _snapController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final audioState = ref.watch(trackAudioProvider);
    final audioNotifier = ref.read(trackAudioProvider.notifier);

    if (!audioState.isPrepared || audioState.currentTrack == null) {
      return const SizedBox.shrink();
    }

    final track = audioState.currentTrack!;
    final coverUrl = track.coverUrl;
    final title = track.title;
    final artistName = track.artist.displayName ?? track.artist.username;

    final authState = ref.watch(authStateProvider).valueOrNull;
    final isOwnTrack = authState is AuthAuthenticated
        ? authState.user.id == track.artist.id
        : false;

    final displayedProgress = audioState.isDragging
        ? (audioState.dragProgress ?? audioState.progress)
        : audioState.progress;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.mobileMiniPlayerHorizontalPadding,
        vertical: AppDimensions.mobileMiniPlayerVerticalPadding,
      ),
      child: GestureDetector(
        onTap: () {
          context.push(RoutePaths.trackPreview(track.id));
        },
        onHorizontalDragUpdate: (details) {
          if (_snapController.isAnimating) _snapController.stop();
          setState(() {
            _dragOffset += details.delta.dx;
          });
        },
        onHorizontalDragEnd: (details) async {
          final threshold = MediaQuery.of(context).size.width * 0.25;
          final velocity = details.primaryVelocity ?? 0;

          if (_dragOffset < -threshold || velocity < -500) {
            // Swipe left -> next
            setState(() => _swipeDirection = -1);
            await audioNotifier.skipNext();
            _snapBack();
          } else if (_dragOffset > threshold || velocity > 500) {
            // Swipe right -> previous
            setState(() => _swipeDirection = 1);
            await audioNotifier.skipPrevious();
            _snapBack();
          } else {
            _snapBack();
          }
        },
        child: Transform.translate(
          offset: Offset(_dragOffset, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                height: AppDimensions.mobileMiniPlayerHeight,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 0.8,
                  ),
                ),
                child: Stack(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        final begin = Offset(
                          _swipeDirection == 1 ? -0.15 : 0.15,
                          0,
                        );
                        final slide = Tween<Offset>(
                          begin: begin,
                          end: Offset.zero,
                        ).animate(animation);
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(position: slide, child: child),
                        );
                      },
                      child: Row(
                        key: ValueKey<int>(track.id),
                        children: [
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              if (audioState.isPlaying) {
                                audioNotifier.pause();
                              } else {
                                audioNotifier.play();
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (coverUrl != null && coverUrl.isNotEmpty)
                                  DecibelCachedImage(
                                    imageUrl: coverUrl,
                                    width: 44,
                                    height: 44,
                                    shape: BoxShape.circle,
                                  )
                                else
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppColors.primaryDark,
                                          AppColors.primary,
                                        ],
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.music_note,
                                      color: Colors.white70,
                                    ),
                                  ),
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withValues(alpha: 0.3),
                                  ),
                                  child: Icon(
                                    audioState.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Track Info
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  artistName,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // Actions
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!isOwnTrack) ...[
                                _MiniFollowIcon(userId: track.artist.id),
                                const SizedBox(width: 10),
                              ],
                              LikeButton(
                                trackId: track.id,
                                isLiked: track.isLiked,
                                likeCount: track.likeCount,
                                iconSize: 22,
                                fontSize: 0, // hide count in mini player
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Progress Bar
                    Positioned(
                      bottom: 0,
                      left: 20,
                      right: 20,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(35),
                        ),
                        child: LinearProgressIndicator(
                          value: displayedProgress,
                          backgroundColor: Colors.transparent,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                          minHeight: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniFollowIcon extends ConsumerWidget {
  const _MiniFollowIcon({required this.userId});
  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followAsync = ref.watch(followStateProvider(userId));

    return followAsync.when(
      loading: () => const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, _) => _iconButton(ref, isFollowing: false),
      data: (isFollowing) => _iconButton(ref, isFollowing: isFollowing),
    );
  }

  Widget _iconButton(WidgetRef ref, {required bool isFollowing}) {
    return GestureDetector(
      onTap: () {
        ref.read(followStateProvider(userId).notifier).toggleFollow();
      },
      child: Icon(
        isFollowing ? Icons.person : Icons.person_add_alt_1,
        color: isFollowing ? AppColors.primary : Colors.white70,
        size: 24,
      ),
    );
  }
}
