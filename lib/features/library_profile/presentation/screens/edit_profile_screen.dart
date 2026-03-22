import 'package:dartz/dartz.dart' show Either;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../upload/presentation/providers/upload_notifier.dart';
import '../../domain/entities/public_profile_social_links.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/profile_edit_provider.dart';
import '../providers/user_profile_provider.dart';
import '../providers/web_profiles_provider.dart';
import '../widgets/genre_selector.dart'; // Retained custom extracted widget
import '../widgets/profile_image_header.dart'; // Retained rich header
import '../widgets/profile_text_field.dart'; // Retained custom extracted widget

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // We keep UI-specific state here (Text Controllers & Form Fields)
  late TextEditingController _bioController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;

  // Local state for complex fields from both branches
  late List<String> _selectedGenres;
  late PublicProfileSocialLinks? _socialLinks;
  late UserProfile? _user;

  @override
  void initState() {
    super.initState();

    // 1. Read necessary provider states (handling Either from userProfileProvider)
    final Either<Failure, UserProfile>? userState = ref
        .read(userProfileProvider)
        .value;
    _user = userState?.fold((failure) => null, (profile) => profile);

    _socialLinks = ref.read(webProfilesProvider);

    // 2. Initialize controllers with existing data
    _bioController = TextEditingController(text: _user?.profileDetails.bio);
    _cityController = TextEditingController(text: _user?.profileDetails.city);
    _countryController = TextEditingController(
      text: _user?.profileDetails.country,
    );

    // 3. Initialize local genre list copy
    _selectedGenres = List<String>.from(
      _user?.profileDetails.favoriteGenres ?? [],
    );
  }

  @override
  void dispose() {
    _bioController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  /// HELPER: Checks if any text or genres have actually changed
  bool _hasChanges(UserProfile? user) {
    if (user == null) return true; // Safety check

    final originalBio = user.profileDetails.bio;
    final originalCity = user.profileDetails.city;
    final originalCountry = user.profileDetails.country;
    final originalGenres = user.profileDetails.favoriteGenres;

    final textChanged =
        _bioController.text.trim() != originalBio ||
        _cityController.text.trim() != originalCity ||
        _countryController.text.trim() != originalCountry;

    final genresChanged =
        _selectedGenres.length != originalGenres.length ||
        !_selectedGenres.every((g) => originalGenres.contains(g));

    return textChanged || genresChanged;
  }

  /// MAIN ACTION: Save changes
  Future<void> _saveProfile() async {
    // 1. Validate Form
    if (!_formKey.currentState!.validate()) return;

    if (!_hasChanges(_user)) {
      context.pop();
      return;
    }

    final success = await ref
        .read(profileEditNotifierProvider.notifier)
        .updateGeneralInfo(
          bio: _bioController.text.trim(),
          city: _cityController.text.trim(),
          country: _countryController.text.trim(),
          genres: _selectedGenres,
          socialLinks: _socialLinks!,
        );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      context.pop();
    } else {
      final errorState = ref.read(profileEditNotifierProvider).error;

      String cleanMessage = 'Failed to update profile.';

      if (errorState != null) {
        final errorStr = errorState.toString();

        // Check for common Dart/Dio offline indicators
        if (errorStr.contains('SocketException') ||
            errorStr.contains('connection error') ||
            errorStr.contains('Failed host lookup') ||
            errorStr.contains('Network is unreachable')) {
          cleanMessage =
              AppConstants.InternetExceptionMessage;
        } else {
          cleanMessage = errorStr.replaceAll('Exception: ', '');
        }
      }

      // 2. Show the clean message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            cleanMessage,
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
    // Watch providers for state changes
    final editState = ref.watch(profileEditNotifierProvider);
    final editNotifier = ref.read(profileEditNotifierProvider.notifier);
    final availableGenres = ref.watch(genreListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.background,
        actions: [
          // Edit Web links button (Retained from feat/prof-state)
          TextButton(
            onPressed: () {
              context.push(RoutePaths.editWebLink);
            },
            child: const Text(
              'Edit Web links',
              style: TextStyle(color: AppColors.accentTeal),
            ),
          ),
          // Save Button/Loading indicator logic
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
              if (_user != null)
                ProfileImageHeader(
                  user: _user!,
                  localCoverPic: editNotifier.localCoverPic,
                  localProfilePic: editNotifier.localProfilePic,
                  onPickImage: (isProfile) => editNotifier.selectAndUploadImage(
                    isProfile: isProfile,
                    context: context,
                  ),
                ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Custom Extracted Text Field Widgets (Retained from HEAD)
                    ProfileTextField(
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
                    ProfileTextField(
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
                    ProfileTextField(
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

                    // 3. Genre Selector (Retained custom extracted widget from HEAD)
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
