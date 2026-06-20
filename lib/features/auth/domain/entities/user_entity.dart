import 'package:equatable/equatable.dart';

/// Represents an authenticated user in the domain layer.
/// Uses Equatable for value-based equality comparison.
class UserEntity extends Equatable {
  final String username;
  final String passwordHash;
  final bool isNewUser;

  const UserEntity({
    required this.username,
    required this.passwordHash,
    this.isNewUser = false,
  });

  @override
  List<Object?> get props => [username, passwordHash, isNewUser];
}
