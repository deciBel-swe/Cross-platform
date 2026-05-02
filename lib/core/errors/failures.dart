/// Failure representations for the domain layer.
abstract class Failure {
  const Failure(this.message);
  final String message;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other.runtimeType == runtimeType &&
        other is Failure &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server failure']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache failure']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failure']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Requested resource not found']);
}
