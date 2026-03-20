import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../upload/presentation/providers/upload_notifier.dart';
import '../notifiers/profile_edit_notifier.dart';
import '../notifiers/user_profile_notifier.dart';
import '../widgets/genre_selector.dart';
import '../widgets/profile_image_header.dart';
import '../widgets/profile_text_field.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // We only keep UI-specific state here (Text Controllers & Form Fields)
  late TextEditingController _bioController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message.replaceAll('Exception: ', ''),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    ref
        .read(profileEditProvider.notifier)
        .updateGeneralInfo(
          bio: _bioController.text.trim(),
          city: _cityController.text.trim(),
          country: _countryController.text.trim(),
          genres: _selectedGenres,
        );
  }

  @override
  Widget build(BuildContext context) {
    final editState = ref.watch(profileEditProvider);
    final editNotifier = ref.read(profileEditProvider.notifier);
    final availableGenres = ref.watch(genreListProvider);
    final user = ref.watch(userProfileProvider).value;
   
    ref.listen<AsyncValue<void>>(profileEditProvider, (previous, next) {
      if (next is AsyncError && !next.isLoading) {
        _showErrorSnackBar(next.error.toString());
      } else if (next is AsyncData && previous is AsyncLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        context.pop();
      }
    });
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.background,
        actions: [
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Image Header - Now perfectly wired to the Notifier!
              ProfileImageHeader(
                user: user!,
                localCoverPic: editNotifier.localCoverPic,
                localProfilePic: editNotifier.localProfilePic,
                onPickImage: (isProfile) =>
                    editNotifier.selectAndUploadImage(isProfile: isProfile),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Extracted Text Field Widgets
                    ProfileTextField(
                      label: 'Bio',
                      controller: _bioController,
                      maxLines: 3,
                      maxLength: 160,
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            value.trim().isEmpty)
                          return 'Bio cannot be only spaces';
                        if (value != null && value.length > 160)
                          return 'Bio must be under 160 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ProfileTextField(
                      label: 'City',
                      controller: _cityController,
                      maxLength: 50,
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            value.trim().isEmpty)
                          return 'City cannot be only spaces';
                        if (value != null &&
                            value.trim().isNotEmpty &&
                            !RegExp(r"^[a-zA-Z\s\-\']+$").hasMatch(value))
                          return 'City contains invalid characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ProfileTextField(
                      label: 'Country',
                      controller: _countryController,
                      maxLength: 50,
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            value.trim().isEmpty)
                          return 'Country cannot be only spaces';
                        if (value != null &&
                            value.trim().isNotEmpty &&
                            !RegExp(r"^[a-zA-Z\s\-\']+$").hasMatch(value))
                          return 'Country contains invalid characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // 3. Genre Selector
                    GenreSelector(
                      availableGenres: availableGenres,
                      selectedGenres: _selectedGenres,
                      onGenreToggled: (genre, isSelected) {
                        setState(() {
                          if (isSelected) {
                            _selectedGenres.add(genre);
                          } else {
                            _selectedGenres.remove(genre);
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
