import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/image_repository.dart';

@Injectable(as: ImageRepository)
class ImageRepositoryImpl implements ImageRepository {
  ImageRepositoryImpl(this._picker);
  final ImagePicker _picker;
  @override
  Future<File?> pickProfileImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      maxHeight: 1000,
      maxWidth: 1800,
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}
