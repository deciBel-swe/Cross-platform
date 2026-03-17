import 'dart:io';

abstract class ImageRepository {
  /// Fetches an image and returns it as a File. Returns null if canceled.
  Future<File?> pickProfileImage();
}
