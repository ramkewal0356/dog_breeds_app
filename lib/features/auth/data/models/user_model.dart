import 'package:dog_breed_app/features/auth/domain/entities/user_entity.dart';

class UserModel {
  final String username;
  final String passwordHash;

  const UserModel({required this.username, required this.passwordHash});

  /// Creates a [UserModel] from a Hive storage map.
  factory UserModel.fromHiveMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] as String,
      passwordHash: map['passwordHash'] as String,
    );
  }

  /// Creates a [UserModel] from a [UserEntity].
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      username: entity.username,
      passwordHash: entity.passwordHash,
    );
  }

  /// Converts this model to a map suitable for Hive storage.
  Map<String, dynamic> toHiveMap() {
    return {'username': username, 'passwordHash': passwordHash};
  }

  /// Converts this model to a domain [UserEntity].
  UserEntity toEntity() {
    return UserEntity(username: username, passwordHash: passwordHash);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          passwordHash == other.passwordHash;

  @override
  int get hashCode => username.hashCode ^ passwordHash.hashCode;

  @override
  String toString() => 'UserModel(username: $username)';
}
