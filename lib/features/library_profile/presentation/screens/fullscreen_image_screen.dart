import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/profile_image_path_utils.dart'; // Adjust import if needed

class FullscreenImagePage extends StatelessWidget {
  const FullscreenImagePage({super.key, required this.imagePath});

  final String? imagePath;

  Widget _buildFullImage(String? path) {
    if (path == null) {
      return const Icon(Icons.person, size: 200, color: Colors.white);
    }

    // Data URI (inline base64) support
    if (ProfileImagePathUtils.isDataUri(path)) {
      final uri = Uri.tryParse(path);
      final data = uri?.data;
      if (data != null) {
        return Image.memory(
          data.contentAsBytes(),
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, size: 100, color: Colors.white),
        );
      }
    }

    // Remote Image
    if (ProfileImagePathUtils.isRemote(path)) {
      return Image.network(
        path,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 100, color: Colors.white),
      );
    }

    // Local File
    final localPath = ProfileImagePathUtils.localFilePath(path);
    if (localPath != null) {
      return Image.file(
        File(localPath),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 100, color: Colors.white),
      );
    }

    return const Icon(Icons.person, size: 200, color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Lets the GoRouter barrierColor show
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0, // Allows pinch-to-zoom
          child: _buildFullImage(imagePath),
        ),
      ),
    );
  }
}
