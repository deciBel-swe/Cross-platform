import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/image_repository.dart';
import '../../data/repositories/image_repository_impl.dart';

final imageRepositoryProvider = Provider<ImageRepository>((ref) {
  return ImageRepositoryImpl();
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