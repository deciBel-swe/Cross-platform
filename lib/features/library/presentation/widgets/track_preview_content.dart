import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library/presentation/widgets/bottom_bar_widget.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../../library_profile/presentation/providers/track_preview_derived_providers.dart';
import '../../../library_profile/presentation/providers/track_preview_provider.dart';
import '../../../library_profile/presentation/widgets/track_preview_background.dart';
import '../../../library_profile/presentation/widgets/track_preview_info.dart';
import '../../../library_profile/presentation/widgets/track_preview_playback_overlay.dart';
import '../../../library_profile/presentation/widgets/track_preview_top_bar.dart';
import '../notifiers/track_comment_notifier.dart';
import 'active_comments_overlay.dart';
import 'comment_reaction_bar.dart';
import 'interactive_waveform.dart';
import 'track_comments_bottom_sheet.dart';

class TrackPreviewContent extends ConsumerWidget {
  const TrackPreviewContent({
    super.key,
    required this.trackId,
    required this.data,
  });

  final int trackId;
  final TrackPreviewData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final track = data.track;
    final trackPeaks = data.trackPeaks;

    final audioState = ref.watch(trackAudioProvider);
    final audioNotifier = ref.read(trackAudioProvider.notifier);
    final playbackUi = ref.watch(trackPreviewPlaybackUiStateProvider);

    final isReady = trackPeaks != null;
    final peaks = isReady
        ? ref.watch(trackPreviewNormalizedPeaksProvider(trackId))
        : null;

    final contentColumn = Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),
            child: Stack(
              children: [
                TrackPreviewBackground(
                  imageUrl: track.coverUrl,
                  isBlurred: isReady ? playbackUi.shouldBlurBackground : true,
                ),
                SafeArea(
                  bottom: false,
                  child: CustomScrollView(
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            const TrackPreviewTopBar(),
                            const SizedBox(height: 16),
                            TrackPreviewInfo(
                              title: track.title,
                              artistName: track.artist.username,
                              tagLabel: 'Behind this track',
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: ActiveCommentsOverlay(trackId: trackId),
                            ),
                            const SizedBox(height: 12),
                            if (isReady)
                              InteractiveWaveform(
                                peaks: peaks as List<double>,
                                audioState: audioState,
                                audioNotifier: audioNotifier,
                              )
                            else
                              const _WaveformNotReady(),
                            const SizedBox(height: 16),
                            _TrackPreviewInputSection(trackId: trackId),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        BottomBarWidget(
          isLiked: isReady,
          likeCount: 28,
          commentCount: 3,
          onLikePressed: () {},
          onCommentPressed: () {
            TrackCommentsBottomSheet.show(
              context,
              trackId: trackId,
              track: track,
            );
          },
          onSharePressed: () {},
          onPlaylistAddPressed: () {},
          onMoreOptionsPressed: () {},
        ),
      ],
    );

    if (!isReady) return contentColumn;

    return TrackPreviewPlaybackOverlay(
      showPlayIcon: playbackUi.showPlayIcon,
      onToggle: () async {
        if (audioState.isPreparing) return;
        if (audioState.isPlaying) {
          await audioNotifier.pause();
        } else {
          await audioNotifier.play();
        }
      },
      child: contentColumn,
    );
  }
}

class _TrackPreviewInputSection extends ConsumerStatefulWidget {
  final int trackId;
  const _TrackPreviewInputSection({required this.trackId});

  @override
  ConsumerState<_TrackPreviewInputSection> createState() =>
      _TrackPreviewInputSectionState();
}

class _TrackPreviewInputSectionState
    extends ConsumerState<_TrackPreviewInputSection> {
  final MentionTextEditingController _commentController =
      MentionTextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _commentController.addListener(() {
      if (_commentController.text.isEmpty) {
        final state = ref.read(trackCommentsProvider(widget.trackId));
        if (state.activeReplyCommentId != null) {
          ref
              .read(trackCommentsProvider(widget.trackId).notifier)
              .clearReplyMode();
        }
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentsState = ref.watch(trackCommentsProvider(widget.trackId));
    final notifier = ref.read(trackCommentsProvider(widget.trackId).notifier);

    ref.listen(trackCommentsProvider(widget.trackId), (prev, next) {
      if (prev?.activeReplyCommentId != null &&
          next.activeReplyCommentId == null) {
        _commentController.clear();
      }

      if (next.replyPrefillText != null &&
          next.replyPrefillText != prev?.replyPrefillText) {
        _commentController.text = next.replyPrefillText!;
        _commentController.selection = TextSelection.fromPosition(
          TextPosition(offset: _commentController.text.length),
        );
        _focusNode.requestFocus();
      }
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (commentsState.activeReplyCommentId != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  const Text(
                    'Replying...',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      _commentController.clear();
                      notifier.clearReplyMode();
                      _focusNode.unfocus();
                    },
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          CommentReactionBar(
            controller: _commentController,
            focusNode: _focusNode,
            onSendTap: (content) {
              notifier.handleSubmit(content);
              _commentController.clear();
              _focusNode.unfocus();
            },
            onReactionTap: (emoji) {
              notifier.handleSubmit(emoji);
              _commentController.clear();
              _focusNode.unfocus();
            },
          ),
        ],
      ),
    );
  }
}

class _WaveformNotReady extends StatelessWidget {
  const _WaveformNotReady();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Waveform is not ready yet.',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
      ),
    );
  }
}
