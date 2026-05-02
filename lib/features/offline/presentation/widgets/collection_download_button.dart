import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/ref_pro_check_extension.dart';
import '../../../library/domain/entities/track.dart';
import '../../../upgrade/presentation/widgets/pro_promotion_bottom_sheet.dart';
import '../../data/datasources/offline_local_data_source.dart';
import '../notifiers/collection_download_notifier.dart';
import '../providers/collection_download_provider.dart';

/// A download button for a collection (playlist or station) that:
/// - shows a promotion dialog for free-tier users.
/// - shows a circular progress indicator while downloading.
/// - shows a check icon when the download completes.
/// - shows an error snackbar on failure.
class CollectionDownloadButton extends ConsumerWidget {
  const CollectionDownloadButton({
    super.key,
    required this.collectionId,
    required this.collectionTitle,
    required this.tracks,
    this.coverUrl,
    this.isStation = false,
    this.iconColor,
  });

  final int collectionId;
  final String collectionTitle;
  final List<Track> tracks;
  final String? coverUrl;
  final bool isStation;
  final Color? iconColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dlState = ref.watch(collectionDownloadProvider(collectionId));

    final isPro = ref.isPro;

    ref.listen(collectionDownloadProvider(collectionId), (
      CollectionDownloadState? previous,
      CollectionDownloadState next,
    ) {
      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    final color = iconColor ?? Theme.of(context).iconTheme.color;

    if (dlState.isDownloading) {
      return SizedBox(
        width: 36,
        height: 36,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: CircularProgressIndicator(
            value: dlState.progress > 0 ? dlState.progress : null,
            strokeWidth: 2.5,
            color: color,
          ),
        ),
      );
    }

    if (dlState.isDone) {
      return Icon(Icons.download_done_rounded, color: color);
    }

    return Semantics(
      button: true,
      label: 'Download collection for offline',
      child: IconButton(
        icon: Icon(Icons.download_outlined, color: color),
        tooltip: 'Download for offline',
        onPressed: () => _onTap(context, ref, isPro: isPro),
      ),
    );
  }

  void _onTap(BuildContext context, WidgetRef ref, {required bool isPro}) {
    if (isPro) {
      final info = OfflineCollectionInfo(
        id: collectionId,
        title: collectionTitle,
        coverUrl: coverUrl,
        trackIds: tracks.map((t) => t.id).toList(),
        isStation: isStation,
      );

      ref
          .read(collectionDownloadProvider(collectionId).notifier)
          .download(tracks: tracks, collectionInfo: info);
    } else {
      ProPromotionBottomSheet.show(context);
    }
  }
}
