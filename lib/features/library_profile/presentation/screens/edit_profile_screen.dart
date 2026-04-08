import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:dartz/dartz.dart' show Either;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../upload/presentation/providers/upload_notifier.dart';
import '../../domain/entities/public_profile_social_links.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/profile_edit_provider.dart';
import '../providers/user_profile_provider.dart';
import '../providers/web_profiles_provider.dart';
import '../widgets/genre_selector.dart';
import '../widgets/profile_image_header.dart';
import '../widgets/profile_text_field.dart';
import 'web_profiles.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _bioController;

  String? _selectedCountry;
  String? _selectedState;

  late List<String> _selectedGenres;
  late UserProfile? _user;

  @override
  void initState() {
    super.initState();

    final Either<Failure, UserProfile>? userState = ref
        .read(userProfileProvider)
        .value;
    _user = userState?.fold((failure) => null, (profile) => profile);

    _bioController = TextEditingController(text: _user?.profileDetails.bio);
    _selectedCountry = _user?.profileDetails.country;
    _selectedState = _user?.profileDetails.city;

    _selectedGenres = List<String>.from(
      _user?.profileDetails.favoriteGenres ?? [],
    );
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  bool _hasChanges(
    UserProfile? user,
    PublicProfileSocialLinks currentSocialLinks,
  ) {
    if (user == null) return true;
    final originalBio = user.profileDetails.bio;
    final originalCity = user.profileDetails.city;
    final originalCountry = user.profileDetails.country;
    final originalGenres = user.profileDetails.favoriteGenres;

    final textChanged =
        _bioController.text.trim() != (originalBio ?? '') ||
        (_selectedState ?? '') != (originalCity ?? '') ||
        (_selectedCountry ?? '') != (originalCountry ?? '');

    final genresChanged =
        _selectedGenres.length != originalGenres.length ||
        !_selectedGenres.every((g) => originalGenres.contains(g));

    final originalSocialLinks =
        user.socialLinks ?? const PublicProfileSocialLinks();
    final socialLinksChanged = PublicProfileSocialLinks.allPlatforms.any((
      platform,
    ) {
      final original =
          originalSocialLinks.valueForPlatform(platform)?.trim() ?? '';
      final current =
          currentSocialLinks.valueForPlatform(platform)?.trim() ?? '';
      return original != current;
    });

    return textChanged || genresChanged || socialLinksChanged;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final currentSocialLinks = ref.read(webProfilesProvider);

    if (!_hasChanges(_user, currentSocialLinks)) {
      context.pop();
      return;
    }
    ref
        .read(profileEditNotifierProvider.notifier)
        .updateGeneralInfo(
          bio: _bioController.text.trim(),
          city: (_selectedState ?? '')
              .replaceAll(
                RegExp(r'\s*Governorate\s*', caseSensitive: false),
                '',
              )
              .trim(),
          country: _selectedCountry ?? '',
          genres: _selectedGenres,
          socialLinks: currentSocialLinks,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(profileEditNotifierProvider, (previous, next) {
      if (previous is AsyncLoading && next is AsyncData) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        context.pop();
      } else if (previous is AsyncLoading && next is AsyncError) {
        final errorStr = next.error.toString();
        String cleanMessage = 'Failed to update profile.';

        if (errorStr.contains('SocketException') ||
            errorStr.contains('connection error') ||
            errorStr.contains('Network is unreachable')) {
          cleanMessage =
              'No internet connection. Please check your network and try again.';
        } else {
          cleanMessage = errorStr.replaceAll('Exception: ', '');
        }

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
    });
    final editState = ref.watch(profileEditNotifierProvider);
    final editNotifier = ref.read(profileEditNotifierProvider.notifier);
    final availableGenres = ref.watch(genreListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.background,
        elevation: 0,
        shadowColor: AppColors.transparent,
        surfaceTintColor: AppColors.background,
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
              // style: TextButton.styleFrom(
              //   backgroundColor: AppColors.primary,
              //   padding: const EdgeInsets.symmetric(horizontal: 16),
              // ),
              onPressed: _saveProfile,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: AppColors.primary,
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

                    // Country → State → City picker
                    CSCPickerPlus(
                      layout: Layout.vertical,
                      flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                      showStates: true,
                      showCities: false,
                      countryStateLanguage:
                          CountryStateLanguage.englishOrNative,
                      currentState: _selectedState,
                      currentCountry: _selectedCountry,
                      dropdownDecoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledDropdownDecoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      selectedItemStyle: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                      dropdownHeadingStyle: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      dropdownItemStyle: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                      dropdownDialogRadius: 12.0,
                      searchBarRadius: 12.0,
                      onCountryChanged: (value) {
                        setState(() {
                          _selectedCountry = value;
                          _selectedState = null;
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          _selectedState = value;
                        });
                      },
                    ),

                    const SizedBox(height: 32),

                    GenreSelector(
                      availableGenres: availableGenres,
                      selectedGenres: _selectedGenres,
                      onGenreToggled: (genre, isSelected) {
                        if (isSelected && _selectedGenres.length >= 10) return;
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
                    const EditProfileLinkScreen(),
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
