import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

abstract class IPickerService {
  Future<File?> pickAudioFile();
  Future<File?> pickCoverImage();

  Future<Duration?> getAudioDuration(String filePath);
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
      // Print the error so you know exactly why it failed
      debugPrint('Error picking audio file: $e');
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

  @override
  Future<Duration?> getAudioDuration(String filePath) async {
    final player = AudioPlayer();
    try {
      final duration = await player.setAudioSource(
        AudioSource.uri(
          Uri.file(filePath),

          tag: MediaItem(
            id: 'duration_check_${DateTime.now().millisecondsSinceEpoch}',
            title: 'Uploading Track...',
          ),
        ),
      );
      return duration;
    } catch (e) {
      debugPrint('Error getting audio duration: $e');
      return null;
    } finally {
      await player.dispose();
    }
  }

  // @override
  // Future<Duration?> getAudioDuration(String filePath) async {
  //   final player = AudioPlayer();
  //   await player.setFilePath(filePath).catchError((_) => null);

  //   await player.processingStateStream
  //       .firstWhere(
  //         (state) =>
  //             state == ProcessingState.ready || state == ProcessingState.idle,
  //       )
  //       .catchError((_) => ProcessingState.idle);

  //   final duration = player.duration;
  //   await player.dispose().catchError((_) {});

  //   return duration;
  // }
}

// Provide it to Riverpod
final pickerServiceProvider = Provider<IPickerService>(
  (ref) => PickerService(),
);
