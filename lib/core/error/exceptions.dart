/// Base exception class for the application.
abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// Exception thrown when no internet connectivity is detected.
class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}

/// Exception thrown when the API returns a server error (5xx status).
class ServerException extends AppException {
  final int statusCode;

  const ServerException({
    required this.statusCode,
    String message = 'Server error occurred',
  }) : super(message);

  @override
  String toString() => 'ServerException($statusCode): $message';
}

/// Exception thrown when JSON parsing or data mapping fails.
class ParseException extends AppException {
  const ParseException([super.message = 'Unable to process breed data']);
}

/// Exception thrown when Hive local storage read/write operations fail.
class CacheException extends AppException {
  const CacheException([super.message = 'Cache operation failed']);
}

/// Exception thrown when authentication credentials are invalid.
class AuthException extends AppException {
  const AuthException([super.message = 'Invalid credentials']);
}

/// Exception thrown when input validation fails.
class ValidationException extends AppException {
  const ValidationException([super.message = 'Input validation failed']);
}
