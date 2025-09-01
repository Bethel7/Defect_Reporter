/// Custom exceptions for low-level error signaling
class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error occurred']);

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error occurred']);

  @override
  String toString() => 'CacheException: $message';
}

class AuthException implements Exception {
  final String message;
  AuthException([this.message = 'Authentication failed']);

  @override
  String toString() => 'AuthException: $message';
}
