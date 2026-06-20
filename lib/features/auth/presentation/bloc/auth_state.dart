import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state
class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  final bool isNewUser;

  const AuthAuthenticated({required this.user, this.isNewUser = false});

  @override
  List<Object?> get props => [user, isNewUser];
}

/// User not authenticated
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Validation error state
class AuthValidationError extends AuthState {
  final String message;

  const AuthValidationError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Login/Register failure state
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Session restored successfully
class AuthSessionRestored extends AuthState {
  final UserEntity user;

  const AuthSessionRestored(this.user);

  @override
  List<Object?> get props => [user];
}

/// Logout successful
class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}
