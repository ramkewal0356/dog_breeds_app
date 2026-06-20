import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// No internet connection available.
class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message =
        'No internet connection. Please check your connection and try again.',
  ]);
}

/// API/server failure.
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    this.statusCode,
    String message = 'Something went wrong. Please try again later.',
  }) : super(message);

  @override
  List<Object?> get props => [message, statusCode];
}

/// Response parsing or mapping failure.
class ParseFailure extends Failure {
  const ParseFailure([super.message = 'Failed to process data.']);
}

/// Local storage (Hive) failure.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to access local storage.']);
}

/// Authentication failure.
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Invalid email or password.']);
}

/// Email validation failure.
class EmailValidationFailure extends Failure {
  const EmailValidationFailure([
    super.message = 'Please enter a valid email address.',
  ]);
}

/// Password validation failure.
class PasswordValidationFailure extends Failure {
  const PasswordValidationFailure([
    super.message = 'Password must be at least 6 characters.',
  ]);
}

/// Generic validation failure.
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Invalid input provided.']);
}

/// Session expired or missing.
class SessionFailure extends Failure {
  const SessionFailure([
    super.message = 'Session expired. Please login again.',
  ]);
}

/// Unauthorized access.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Unauthorized access.']);
}

/// Resource not found.
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Requested resource not found.']);
}

/// Request timeout.
class TimeoutFailure extends Failure {
  const TimeoutFailure([
    super.message = 'Request timed out. Please try again.',
  ]);
}

/// Unknown exception.
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong.']);
}
