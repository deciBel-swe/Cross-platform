class ProfileImagePathUtils {
  ProfileImagePathUtils._();

  static bool isRemote(String path) {
    final uri = Uri.tryParse(path);
    final scheme = uri?.scheme.toLowerCase();
    return scheme == 'http' || scheme == 'https';
  }

  static String? localFilePath(String path) {
    // Plain paths (no scheme) are assumed to be local file paths.
    final uri = Uri.tryParse(path);
    if (uri == null || uri.scheme.isEmpty) {
      return path;
    }

    final scheme = uri.scheme.toLowerCase();

    // file:// URIs -> convert to platform file path
    if (scheme == 'file') {
      return uri.toFilePath();
    }

    // On Windows absolute paths like "C:\\..." may be parsed with a scheme;
    // detect drive-letter paths and treat them as local.
    final windowsDrive = RegExp(r'^[a-zA-Z]:\\|^[a-zA-Z]:/');
    if (windowsDrive.hasMatch(path)) {
      return path;
    }

    return null;
  }

  static bool isDataUri(String path) {
    final uri = Uri.tryParse(path);
    return uri != null && uri.scheme.toLowerCase() == 'data';
  }
}
