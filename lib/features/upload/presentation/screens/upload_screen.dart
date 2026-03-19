import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/upload_notifier.dart';
import '../widgets/files_selection_header.dart';
import '../widgets/privacy_settings.dart';
import '../widgets/submit_section.dart';
import '../widgets/track_details_form.dart';
import '../widgets/track_info_checklist.dart';

/// The root Presentation screen for the Track Upload feature.
///
/// It holds the "GlobalKey" for the form state
/// and structures the modular sub-widgets sequentially to build the final UI.
class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  // key to validate the form whin the user submit the track
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Get the metadata from the notifier to edit its parameters in there fields
    final uploadState = ref.watch(uploadNotifierProvider);
    final metadata = uploadState.value;

    // Safety check: Show a loader while the Notifier initializes its starting state
    if (metadata == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TrackInfoChecklist(metadata: metadata),
              const SizedBox(height: 24),

              const FileSelectionHeader(),
              const SizedBox(height: 24),

              // The main card containing the metadata and privacy forms
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderDark),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [TrackDetailsForm(), PrivacySettings()],
                ),
              ),
              const SizedBox(height: 32),

              SubmitSection(formKey: _formKey),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
