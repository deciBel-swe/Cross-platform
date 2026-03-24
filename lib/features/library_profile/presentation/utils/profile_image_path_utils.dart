class ProfileImagePathUtils {
  ProfileImagePathUtils._();

  static bool isRemote(String path) {
    final uri = Uri.tryParse(path);
    final scheme = uri?.scheme.toLowerCase();
    return scheme == 'http' || scheme == 'https';
  }

  static String? localFilePath(String path) {
    final uri = Uri.tryParse(path);
    if (uri == null || uri.scheme.isEmpty) {
      return path;
    }

    if (uri.scheme.toLowerCase() == 'file') {
      return uri.toFilePath();
    }

    return null;
  }
}
