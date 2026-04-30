import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/decibel_cached_image.dart';
import '../../../home/presentation/providers/history_provider.dart';
import '../../../library_profile/domain/entities/user_profile.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../../library_profile/presentation/providers/user_profile_provider.dart';
import '../../../library_profile/presentation/widgets/track_details.dart';
import '../../../upgrade/presentation/widgets/get_pro_button.dart';
import '../../domain/entities/track.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = ResponsiveUtils.isDesktop(context);

    void goToProfile() {
      context.push(RoutePaths.profile);
    }

    void goToSettings() {
      context.push(RoutePaths.settings);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: AppColors.background,
              scrolledUnderElevation: 0,
              title: Semantics(
                header: true,
                child: const Text('Library', style: AppTextStyles.sectionTitle),
              ),
              actions: [
                const GetProButton(),
                IconButton(
                  onPressed: goToSettings,
                  icon: const Icon(Icons.settings_outlined),
                  tooltip: 'Settings',
                ),
                IconButton(
                  onPressed: goToProfile,
                  icon: const Icon(Icons.account_circle),
                  tooltip: 'Profile',
                ),
              ],
            ),
      body: _LibraryTab(isDesktop: isDesktop),
    );
  }
}

class _LibraryTab extends ConsumerWidget {
  const _LibraryTab({required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final userProfile = profileAsync.valueOrNull?.fold(
      (_) => null,
      (profile) => profile,
    );
    final isPro =
        userProfile?.tier == UserTier.pro ||
        userProfile?.tier == UserTier.artistPro;

    // final isPro=true;
    return ListView(
      // Make padding responsive to match Home and Search screens
      padding: EdgeInsets.fromLTRB(
        isDesktop ? AppDimensions.paddingXl : AppDimensions.paddingMd,
        isDesktop ? AppDimensions.paddingXl : AppDimensions.paddingSm,
        isDesktop ? AppDimensions.paddingXl : AppDimensions.paddingMd,
        AppDimensions.mobileMiniPlayerReservedSpace,
      ),
      children: [
        if (isDesktop) ...[
          const _DesktopLibraryHeader(),
          const SizedBox(height: AppDimensions.paddingLg),
        ],

        _NavigationRow(
          title: 'Playlists',
          onTap: () {
            context.push(RoutePaths.playlists);
          },
        ),
        _NavigationRow(
          title: 'Following',
          onTap: () => context.go(RoutePaths.libraryFollowing),
        ),
        _NavigationRow(
          title: 'Your uploads',
          onTap: () => context.go(RoutePaths.uploadLibrary),
        ),
        _NavigationRow(
          title: 'Downloads',
          onTap: () => context.go(RoutePaths.libraryDownloads),
          enabled: isPro,
        ),
        _NavigationRow(
          title: 'Your likes',
          onTap: () => context.go(RoutePaths.libraryLikes),
        ),
        _NavigationRow(
          title: 'Your reposts',
          onTap: () => context.go(RoutePaths.libraryReposts),
        ),
        const SizedBox(height: AppDimensions.paddingXl),
        const _RecentlyPlayedLibraryRail(),
        const SizedBox(height: AppDimensions.paddingXl),
        const _ListeningHistoryPreview(),
        const SizedBox(height: AppDimensions.paddingLg),
      ],
    );
  }
}

class _DesktopLibraryHeader extends StatelessWidget {
  const _DesktopLibraryHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: const Text('Library', style: AppTextStyles.sectionTitle),
          ),
        ),
      ],
    );
  }
}

class _RecentlyPlayedLibraryRail extends ConsumerWidget {
  const _RecentlyPlayedLibraryRail();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return historyAsync.when(
      loading: () => const _SectionLoading(title: 'Recently played'),
      error: (error, _) =>
          _SectionError(title: 'Recently played', message: error.toString()),
      data: (history) {
        final tracks = history.tracks.take(8).toList(growable: false);
        if (tracks.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LibrarySectionHeader(
                title: 'Recently played',
                onSeeAll: () => context.push(RoutePaths.recentlyPlayed),
              ),
              const SizedBox(height: AppDimensions.paddingSm),
              const _SectionEmpty(message: 'No recently played tracks yet.'),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LibrarySectionHeader(
              title: 'Recently played',
              onSeeAll: () => context.push(RoutePaths.recentlyPlayed),
            ),
            const SizedBox(height: AppDimensions.paddingSm),
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: tracks.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppDimensions.paddingMd),
                itemBuilder: (context, index) {
                  final track = tracks[index];
                  return _RecentLibraryCard(
                    track: track,
                    onTap: () =>
                        _playHistoryTrack(context, ref, track, history.tracks),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ListeningHistoryPreview extends ConsumerWidget {
  const _ListeningHistoryPreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return historyAsync.when(
      loading: () => const _SectionLoading(title: 'Listening history'),
      error: (error, _) =>
          _SectionError(title: 'Listening history', message: error.toString()),
      data: (history) {
        final tracks = history.tracks.take(5).toList(growable: false);
        if (tracks.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LibrarySectionHeader(
                title: 'Listening history',
                onSeeAll: () => context.push(RoutePaths.recentlyPlayed),
              ),
              const SizedBox(height: AppDimensions.paddingSm),
              const _SectionEmpty(message: 'No listening history yet.'),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LibrarySectionHeader(
              title: 'Listening history',
              onSeeAll: () => context.push(RoutePaths.recentlyPlayed),
            ),
            const SizedBox(height: AppDimensions.paddingSm),
            ...tracks.map(
              (track) => _HistoryLibraryRow(
                track: track,
                onTap: () =>
                    _playHistoryTrack(context, ref, track, history.tracks),
                onMoreOptions: () {
                  unawaited(TrackDetails.show(context, track, ref));
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LibrarySectionHeader extends StatelessWidget {
  const _LibrarySectionHeader({required this.title, required this.onSeeAll});

  final String title;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              title,
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 16),
            ),
          ),
        ),
        Semantics(
          button: true,
          label: 'See all $title',
          child: TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(
              backgroundColor: AppColors.surfaceVariant,
              foregroundColor: AppColors.textPrimary,
              minimumSize: const Size(0, 28),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            child: const Text('See All'),
          ),
        ),
      ],
    );
  }
}

class _RecentLibraryCard extends StatelessWidget {
  const _RecentLibraryCard({required this.track, required this.onTap});

  final Track track;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final artistName = _artistName(track);

    return Semantics(
      button: true,
      enabled: track.isPlayable,
      label: 'Play ${track.title} by $artistName',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 92,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HistoryArtwork(track: track, size: 92),
              const SizedBox(height: AppDimensions.paddingXs),
              Text(
                track.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                artistName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryLibraryRow extends StatelessWidget {
  const _HistoryLibraryRow({
    required this.track,
    required this.onTap,
    required this.onMoreOptions,
  });

  final Track track;
  final VoidCallback onTap;
  final VoidCallback onMoreOptions;

  @override
  Widget build(BuildContext context) {
    final artistName = _artistName(track);

    return Semantics(
      button: true,
      enabled: track.isPlayable,
      label: 'Play ${track.title} by $artistName',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          excludeFromSemantics: true,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.paddingXs,
            ),
            child: Row(
              children: [
                _HistoryArtwork(track: track, size: 48),
                const SizedBox(width: AppDimensions.paddingSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.cardTitle.copyWith(fontSize: 13),
                      ),
                      Text(
                        artistName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '${_formatCount(track.playCount)} plays',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textHint,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'More options',
                  onPressed: onMoreOptions,
                  icon: const Icon(
                    Icons.more_vert,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryArtwork extends StatelessWidget {
  const _HistoryArtwork({required this.track, required this.size});

  final Track track;
  final double size;

  @override
  Widget build(BuildContext context) {
    final coverUrl = track.coverUrl?.trim();
    final fallback = Container(
      width: size,
      height: size,
      color: AppColors.surfaceVariant,
      child: Icon(
        Icons.music_note,
        color: AppColors.textSecondary,
        size: size * 0.42,
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: coverUrl != null && coverUrl.isNotEmpty
          ? DecibelCachedImage(
              imageUrl: coverUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorWidget: fallback,
            )
          : fallback,
    );
  }
}

class _SectionLoading extends StatelessWidget {
  const _SectionLoading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading $title',
      child: SizedBox(
        height: 96,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: AppDimensions.paddingMd),
            const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}

class _SectionError extends StatelessWidget {
  const _SectionError({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title failed to load',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.sectionTitle.copyWith(fontSize: 16)),
          const SizedBox(height: AppDimensions.paddingSm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: AppColors.borderDark, width: 0.6),
            ),
            child: Text(
              message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionEmpty extends StatelessWidget {
  const _SectionEmpty({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: message,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: AppColors.borderDark, width: 0.6),
        ),
        child: Text(
          message,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _NavigationRow extends StatelessWidget {
  const _NavigationRow({
    required this.title,
    required this.onTap,
    this.enabled = true,
  });

  final String title;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = enabled ? AppColors.textPrimary : AppColors.textHint;

    return Semantics(
      button: true,
      enabled: enabled,
      label: title,
      hint: enabled ? 'Navigate to $title' : 'Pro feature only, unavailable.',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          excludeFromSemantics: true,
          onTap: enabled
              ? onTap
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('This feature is for Pro users only.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (!enabled)
                  const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.textHint,
                    size: 20,
                  )
                else
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                    size: 28,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _playHistoryTrack(
  BuildContext context,
  WidgetRef ref,
  Track track,
  List<Track> queue,
) async {
  if (!track.isPlayable) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This track is not available for playback.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    return;
  }

  await ref
      .read(trackAudioProvider.notifier)
      .playTrack(track: track, queue: queue, autoPlay: true);
}

String _artistName(Track track) {
  return track.artist.displayName?.trim().isNotEmpty == true
      ? track.artist.displayName!
      : track.artist.username;
}

String _formatCount(int value) {
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)}M';
  }
  if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}K';
  }
  return value.toString();
}
