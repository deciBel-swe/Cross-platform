import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/track_social_provider.dart';

class TrackReportBottomSheet extends ConsumerStatefulWidget {
  const TrackReportBottomSheet({super.key, required this.trackId});

  final int trackId;

  static Future<void> show(BuildContext context, int trackId) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TrackReportBottomSheet(trackId: trackId),
    );
  }

  @override
  ConsumerState<TrackReportBottomSheet> createState() =>
      _TrackReportBottomSheetState();
}

class _TrackReportBottomSheetState
    extends ConsumerState<TrackReportBottomSheet> {
  String? _selectedReason;
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  final List<String> _reasons = [
    'Inappropriate content',
    'Copyright infringement',
    'Spam',
    'Other',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedReason == null) return;

    setState(() => _isSubmitting = true);

    try {
      await ref
          .read(trackSocialRepositoryProvider)
          .reportTrack(
            trackId: widget.trackId,
            reason: _selectedReason!,
            description: _descriptionController.text.isNotEmpty
                ? _descriptionController.text
                : null,
          );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Track reported successfully.')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to report track: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Report Track',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingLg),
              const Text(
                'Why are you reporting this track?',
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: AppDimensions.paddingMd),
              RadioGroup<String?>(
                groupValue: _selectedReason,
                onChanged: (value) => setState(() => _selectedReason = value),
                child: Column(
                  children: _reasons
                      .map(
                        (reason) => RadioListTile<String>(
                          title: Text(
                            reason,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          value: reason,
                          activeColor: AppColors.primary,
                          contentPadding: EdgeInsets.zero,
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingMd),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Additional details (optional)',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLg),
              ElevatedButton(
                onPressed: _selectedReason == null || _isSubmitting
                    ? null
                    : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text('Submit Report'),
              ),
              const SizedBox(height: AppDimensions.paddingLg),
            ],
          ),
        ),
      ),
    );
  }
}
