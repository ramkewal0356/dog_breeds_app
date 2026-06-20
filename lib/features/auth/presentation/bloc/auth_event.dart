import 'package:equatable/equatable.dart';

/// Base class for all authentication events.
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check if a valid session exists on app launch.
class CheckSessionEvent extends AuthEvent {
  const CheckSessionEvent();
}

/// Event to login (or auto-register) with the given credentials.
class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  const LoginEvent({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}

/// Event to logout the current user and clear the session.
class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}
