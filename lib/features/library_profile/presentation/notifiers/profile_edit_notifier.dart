import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui; // Needed for toByteData

import 'package:croppy/croppy.dart' as cp;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/public_profile_social_links.dart';
import '../../domain/repositories/update_image.dart';
import '../providers/user_profile_provider.dart';
import '../providers/web_profiles_provider.dart';

// Added this based on Riverpod 2.0 AsyncNotifier usage
final profileEditProvider = AsyncNotifierProvider<ProfileEditNotifier, void>(
  ProfileEditNotifier.new,
);

class ProfileEditNotifier extends AsyncNotifier<void> {
  File? _localProfilePic;
  File? _localCoverPic;

  File? get localProfilePic => _localProfilePic;
  File? get localCoverPic => _localCoverPic;

  final ImagePicker _picker = ImagePicker();

  @override
  FutureOr<void> build() {}

  /// HELPER: Unified Cropping for Windows, Android, and iOS
  /// HELPER: This replaces the native ImageCropper logic for Windows/Cross-platform
  Future<CroppedFile?> _performCrop(
    BuildContext context,
    String path,
    bool isProfile,
  ) async {
    // FIX: Using the correct showMaterialImageCropper API for version 1.4.1
    final result = await cp.showMaterialImageCropper(
      context,
      imageProvider: FileImage(File(path)),
      allowedAspectRatios: [
        isProfile
            ? const cp.CropAspectRatio(width: 1, height: 1)
            : const cp.CropAspectRatio(width: 16, height: 9),
      ],
      // FIX: cropPathFn must return a CropShape object, not a Path.
      // We use the built-in factory functions to avoid "PathBuilder" errors.
      cropPathFn: isProfile ? cp.ellipseCropShapeFn : cp.aabbCropShapeFn,
    );

    if (result == null) return null;

    // Convert the result to a file so it remains compatible with your existing logic
    final byteData = await result.uiImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    if (byteData == null) return null;

    final tempDir = await getTemporaryDirectory();
    final tempPath =
        '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = await File(
      tempPath,
    ).writeAsBytes(byteData.buffer.asUint8List());

    return CroppedFile(file.path);
  }

  /// MAIN ACTION: Pick, Crop, and Upload
  Future<void> selectAndUploadImage({
    required BuildContext context,
    required bool isProfile,
  }) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;
      if (!context.mounted) return;
      final croppedFile = await _performCrop(
        context,
        pickedFile.path,
        isProfile,
      );
      if (croppedFile == null) return;

      final file = File(croppedFile.path);

      if (isProfile) {
        _localProfilePic = file;
      } else {
        _localCoverPic = file;
      }
      state = const AsyncData(null);

      final useCase = getIt<UpdateProfileImagesUseCase>();
      final result = await useCase.execute(
        profilePic: isProfile ? file : null,
        coverPic: !isProfile ? file : null,
      );

      result.fold((failure) {
        final errorStr = failure.message.toString();
        if (errorStr.contains('SocketException') ||
            errorStr.contains('connection error') ||
            errorStr.contains('Network is unreachable')) {
          state = AsyncError(
            'No internet. Image kept locally but not uploaded.',
            StackTrace.current,
          );
        } else {
          state = AsyncError(failure.message, StackTrace.current);
        }
      }, (success) => ref.invalidate(userProfileProvider));
    } catch (e) {
      state = AsyncError("Failed to process image: $e", StackTrace.current);
    }
  }

  Future<bool> updateGeneralInfo({
    required String bio,
    required String city,
    required String country,
    required List<String> genres,
    required PublicProfileSocialLinks socialLinks,
  }) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(profileRepositoryProvider);

      final result = await repository.updateProfile(
        bio: bio,
        city: city,
        country: country,
        favoriteGenres: genres,
        socialLinks: socialLinks,
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
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
      return false;
    }
  }
}
