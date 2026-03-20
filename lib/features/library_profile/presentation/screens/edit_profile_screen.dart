import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../upload/presentation/providers/upload_notifier.dart';
import '../notifiers/profile_edit_notifier.dart';
import '../notifiers/user_profile_notifier.dart';

// Assuming you put your genreListProvider in a file like this:
// import '../providers/genre_list_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _bioController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;

  // 1. Add local state to track the user's genre selections
  late List<String> _selectedGenres;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProfileProvider).value;

    _bioController = TextEditingController(text: user?.profileDetails.bio);
    _cityController = TextEditingController(text: user?.profileDetails.city);
    _countryController = TextEditingController(
      text: user?.profileDetails.country,
    );

    // 2. Initialize the selected genres with a mutable copy of the user's current data
    _selectedGenres = List<String>.from(
      user?.profileDetails.favoriteGenres ?? [],
    );
  }

  @override
  void dispose() {
    _bioController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  bool _hasChanges() {
    final user = ref.read(userProfileProvider).value;
    final originalBio = user?.profileDetails.bio ?? '';
    final originalCity = user?.profileDetails.city ?? '';
    final originalCountry = user?.profileDetails.country ?? '';
    final originalGenres = user?.profileDetails.favoriteGenres ?? [];

    final textChanged =
        _bioController.text.trim() != originalBio ||
        _cityController.text.trim() != originalCity ||
        _countryController.text.trim() != originalCountry;

    // 3. Compare the new genre list against the original list
    final genresChanged =
        _selectedGenres.length != originalGenres.length ||
        !_selectedGenres.every((g) => originalGenres.contains(g));

    return textChanged || genresChanged;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_hasChanges()) {
      context.pop();
      return;
    }

    final success = await ref
        .read(profileEditProvider.notifier)
        .updateGeneralInfo(
          bio: _bioController.text.trim(),
          city: _cityController.text.trim(),
          country: _countryController.text.trim(),
          // 4. Pass the local state list to the save method
          genres: _selectedGenres,
        );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      context.pop();
    } else {
      final errorState = ref.read(profileEditProvider).error;
      final errorMessage =
          errorState?.toString() ?? 'Failed to update profile.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage.replaceAll('Exception: ', ''),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final editState = ref.watch(profileEditProvider);
    // 5. Watch the available genres from your provider
    final availableGenres = ref.watch(genreListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.background,
        actions: [
          TextButton(
            onPressed: () {
              context.push(RoutePaths.editWebLink);
            },
            child: const Text(
              'Edit Web links',
              style: TextStyle(color: AppColors.accentTeal),
            ),
          ),
          if (editState is AsyncLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.google,
                  ),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveProfile,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: AppColors.google,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align text nicely to the left
            children: [
              _buildTextFormField(
                label: 'Bio',

                controller: _bioController,
                maxLines: 3,
                maxLength: 160,
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      value.trim().isEmpty) {
                    return 'Bio cannot be only spaces';
                  }
                  if (value != null && value.length > 160) {
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
                  if (value != null &&
                      value.isNotEmpty &&
                      value.trim().isEmpty) {
                    return 'City cannot be only spaces';
                  }
                  if (value != null &&
                      value.trim().isNotEmpty &&
                      !RegExp(r"^[a-zA-Z\s\-\']+$").hasMatch(value)) {
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
                  if (value != null &&
                      value.isNotEmpty &&
                      value.trim().isEmpty) {
                    return 'Country cannot be only spaces';
                  }
                  if (value != null &&
                      value.trim().isNotEmpty &&
                      !RegExp(r"^[a-zA-Z\s\-\']+$").hasMatch(value)) {
                    return 'Country contains invalid characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // 6. The Genre Selection UI
              Text(
                'Favorite Genres',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: availableGenres.map((genre) {
                  final isSelected = _selectedGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedGenres.add(genre);
                        } else {
                          _selectedGenres.remove(genre);
                        }
                      });
                    },
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.google.withOpacity(0.2),
                    checkmarkColor: AppColors.google,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.google
                          : AppColors.onPrimary,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppColors.google : Colors.transparent,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40), // Extra padding at the bottom
            ],
          ),
        ),
      ),
    );
  }

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
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        counterStyle: const TextStyle(color: AppColors.surface),
        errorStyle: const TextStyle(color: Colors.redAccent),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.surface),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.google),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}
