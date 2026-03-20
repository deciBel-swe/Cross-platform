import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

abstract class IPickerService {
  Future<File?> pickAudioFile();
  Future<File?> pickCoverImage();
}

class PickerService implements IPickerService {
  bool _isAudioPickerActive = false;

  @override
  Future<File?> pickAudioFile() async {
    if (_isAudioPickerActive) return null;
    _isAudioPickerActive = true;

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav'],
      );
      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      _isAudioPickerActive = false;
    }
  }

  @override
  Future<File?> pickCoverImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }
}

// Provide it to Riverpod
final pickerServiceProvider = Provider<IPickerService>(
  (ref) => PickerService(),
);
