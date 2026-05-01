/// Base class for application failures / exceptions.
abstract class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error occurred']);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Cache error occurred']);
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}

class AuthException extends AppException {
  const AuthException([super.message = 'Authentication failed']);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Requested resource not found']);
}

class ServiceUnavailableException extends AppException {
  const ServiceUnavailableException([
    super.message = 'Service temporarily unavailable. Please try again later',
  ]);
}
