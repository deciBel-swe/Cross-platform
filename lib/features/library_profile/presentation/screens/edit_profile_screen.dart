import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../notifiers/profile_edit_notifier.dart';
import '../notifiers/user_profile_notifier.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  // 1. Add a form key to trigger validations
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _bioController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current data from the provider
    final user = ref.read(userProfileProvider).value;
    _bioController = TextEditingController(text: user?.profileDetails.bio);
    _cityController = TextEditingController(text: user?.profileDetails.city);
    _countryController = TextEditingController(text: user?.profileDetails.country);
  }

  @override
  void dispose() {
    _bioController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  // 2. Optimization: Check if data actually changed before making an API call
  bool _hasChanges() {
    final user = ref.read(userProfileProvider).value;
    final originalBio = user?.profileDetails.bio ?? '';
    final originalCity = user?.profileDetails.city ?? '';
    final originalCountry = user?.profileDetails.country ?? '';

    // Fixed: Use || (OR) instead of && (AND)
    return _bioController.text.trim() != originalBio ||
           _cityController.text.trim() != originalCity ||
           _countryController.text.trim() != originalCountry;
  }
  Future<void> _saveProfile() async {
    // 1. Trigger Validations
    if (!_formKey.currentState!.validate()) return;

    // 2. Check if anything actually changed
    if (!_hasChanges()) {
      Navigator.pop(context);
      return;
    }

    final success = await ref.read(profileEditProvider.notifier).updateGeneralInfo(
          bio: _bioController.text.trim(),
          city: _cityController.text.trim(),
          country: _countryController.text.trim(),
          genres: ref.read(userProfileProvider).value?.profileDetails.favoriteGenres ?? [],
        );

    // Always check if the widget is still on screen after an 'await'
    if (!mounted) return; 

    if (success) {
      // Success State
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context);
    } else {
      // Error State
      // Grab the exact error message we saved in the AsyncError state of the Notifier
      final errorState = ref.read(profileEditProvider).error;
      final errorMessage = errorState?.toString() ?? 'Failed to update profile. Please try again.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            // Strip out "Exception: " if it's there for a cleaner UI
            errorMessage.replaceAll('Exception: ', ''),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent, // Makes errors visually distinct
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final editState = ref.watch(profileEditProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.background,
        actions: [
          if (editState is AsyncLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.google),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveProfile,
              child: const Text('Save', style: TextStyle(color: AppColors.google, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      // 4. Wrap your form elements in the Form widget
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTextFormField(
                label: 'Bio',
                controller: _bioController,
                maxLines: 3,
                maxLength: 160,
                validator: (value) {
                  // STRICT CHECK: Rejects completely empty fields AND spaces-only fields
                  if (value == null || value.trim().isEmpty) {
                    return 'Bio cannot be empty';
                  }
                  if (value.length > 160) {
                    return 'Bio must be under 160 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                label: 'City',
                controller: _cityController,
                maxLength: 50,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'City cannot be empty';
                  }
                  // Regex checks for letters, spaces, hyphens, and apostrophes
                  if (!RegExp(r"^[a-zA-Z\s\-\']+$").hasMatch(value.trim())) {
                    return 'City contains invalid characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                label: 'Country',
                controller: _countryController,
                maxLength: 50,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Country cannot be empty';
                  }
                  if (!RegExp(r"^[a-zA-Z\s\-\']+$").hasMatch(value.trim())) {
                    return 'Country contains invalid characters';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 5. Upgraded to TextFormField to support validation logic
  Widget _buildTextFormField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
      style: const TextStyle(color: AppColors.onPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.surface),
        counterStyle: const TextStyle(color: AppColors.surface), // For the character count
        errorStyle: const TextStyle(color: Colors.redAccent), // Make errors pop
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.surface)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.google)),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
        focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
      ),
    );
  }
}