import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/update_image.dart';
import 'user_profile_notifier.dart';

final profileEditProvider =
    StateNotifierProvider<ProfileEditNotifier, AsyncValue<void>>(
      (ref) => ProfileEditNotifier(ref),
    );

class ProfileEditNotifier extends StateNotifier<AsyncValue<void>> {
  ProfileEditNotifier(this.ref) : super(const AsyncData(null));
  final Ref ref;
  File? _localProfilePic;
  File? _localCoverPic;

  File? get localProfilePic => _localProfilePic;
  File? get localCoverPic => _localCoverPic;

  final ImagePicker _picker = ImagePicker();

  Future<void> selectAndUploadImage({required bool isProfile}) async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;

      final cropped = await _performCrop(picked.path, isProfile);
      if (cropped == null) return;
      final file = File(cropped.path);

      if (isProfile)
        _localProfilePic = file;
      else
        _localCoverPic = file;

      state = const AsyncData(null); 

      final useCase = getIt<UpdateProfileImagesUseCase>();
      final result = await useCase.execute(
        profilePic: isProfile ? file : null,
        coverPic: !isProfile ? file : null,
      );

      result.fold(
        (failure) {
          if (isProfile)
            _localProfilePic = null;
          else
            _localCoverPic = null;
          state = AsyncError(failure.message, StackTrace.current);
        },
        (success) {
          ref.invalidate(userProfileProvider);
        },
      );
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  Future<CroppedFile?> _performCrop(String path, bool isProfile) {
    return ImageCropper().cropImage(
      sourcePath: path,
      aspectRatio: isProfile
          ? const CropAspectRatio(ratioX: 1, ratioY: 1)
          : const CropAspectRatio(ratioX: 16, ratioY: 9),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Photo',
          toolbarColor: AppColors.background,
          toolbarWidgetColor: AppColors.apple,
          initAspectRatio: isProfile
              ? CropAspectRatioPreset.square
              : CropAspectRatioPreset.ratio16x9,
          lockAspectRatio: true,
          cropStyle: isProfile ? CropStyle.circle : CropStyle.rectangle,
        ),
        IOSUiSettings(
          title: 'Crop Photo',
          aspectRatioLockEnabled: true,
          cropStyle: isProfile ? CropStyle.circle : CropStyle.rectangle,
        ),
      ],
    );
  }

  Future<bool> updateGeneralInfo({
    required String bio,
    required String city,
    required String country,
    required List<String> genres,
  }) async {
    state = const AsyncLoading();

    final repository = getIt<ProfileRepository>();
    final result = await repository.updateProfile(
      bio: bio,
      city: city,
      country: country,
      favoriteGenres: genres,
    );

    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (success) {
        ref.invalidate(userProfileProvider);
        state = const AsyncData(null);
        return true;
      },
    );
  }
}
