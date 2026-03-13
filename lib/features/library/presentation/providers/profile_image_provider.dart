import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../domain/repositories/image_repository.dart';

final imageRepositoryProvider = Provider<ImageRepository>((ref) {
  return getIt<ImageRepository>();
});

class ProfileImageNotifier extends Notifier<File?> {
  @override
  File? build() => null; 

  Future<void> pickImage() async {
    final repository = ref.read(imageRepositoryProvider);
    
    final file = await repository.pickProfileImage();
    
    if (file != null) {
      state = file;
    }
  }
}

final profileImageProvider = NotifierProvider<ProfileImageNotifier, File?>(() {
  return ProfileImageNotifier();
});