import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';

abstract class IPickerService {
  Future<File?> pickAudioFile();
  Future<File?> pickCoverImage();

  Future<Duration?> getAudioDuration(String filePath);
}

class PickerService implements IPickerService {
  @override
  Future<File?> pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav'],
    );
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
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

  @override
  Future<Duration?> getAudioDuration(String filePath) async {
    final player = AudioPlayer();
    await player.setFilePath(filePath).catchError((_) => null);

    await player.processingStateStream
        .firstWhere(
          (state) =>
              state == ProcessingState.ready || state == ProcessingState.idle,
        )
        .catchError((_) => ProcessingState.idle);

    final duration = player.duration;
    await player.dispose().catchError((_) {});

    return duration;
  }
}

// Provide it to Riverpod
final pickerServiceProvider = Provider<IPickerService>(
  (ref) => PickerService(),
);
