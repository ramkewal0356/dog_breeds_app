import 'package:hive/hive.dart';

import 'package:dog_breed_app/core/error/exceptions.dart';
import 'package:dog_breed_app/features/auth/data/models/user_model.dart';

/// Abstract contract for auth-related local storage operations.
///
/// Provides user CRUD on the "users" Hive box and session management
/// on the "session" Hive box.
abstract class AuthLocalDataSource {
  /// Retrieves a user by [username] from the users box.
  /// Returns `null` if the user does not exist.
  Future<UserModel?> getUser(String username);

  /// Saves a [user] to the users box, keyed by username.
  Future<void> saveUser(UserModel user);

  /// Retrieves the currently stored session user.
  /// Returns `null` if no session exists.
  Future<UserModel?> getSession();

  /// Persists a session for the given [user].
  Future<void> saveSession(UserModel user);

  /// Removes the current session from storage.
  Future<void> clearSession();
}

/// Hive-backed implementation of [AuthLocalDataSource].
///
/// Receives pre-opened Hive boxes via constructor injection for testability.
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<Map> usersBox;
  final Box<Map> sessionBox;

  static const String _sessionKey = 'current_user';

  AuthLocalDataSourceImpl({
    required this.usersBox,
    required this.sessionBox,
  });

  @override
  Future<UserModel?> getUser(String username) async {
    try {
      final data = usersBox.get(username);
      if (data == null) return null;
      return UserModel.fromHiveMap(Map<String, dynamic>.from(data));
    } catch (e) {
      throw CacheException('Failed to get user: $e');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      await usersBox.put(user.username, user.toHiveMap());
    } catch (e) {
      throw CacheException('Failed to save user: $e');
    }
  }

  @override
  Future<UserModel?> getSession() async {
    try {
      final data = sessionBox.get(_sessionKey);
      if (data == null) return null;
      return UserModel.fromHiveMap(Map<String, dynamic>.from(data));
    } catch (e) {
      throw CacheException('Failed to get session: $e');
    }
  }

  @override
  Future<void> saveSession(UserModel user) async {
    try {
      await sessionBox.put(_sessionKey, user.toHiveMap());
    } catch (e) {
      throw CacheException('Failed to save session: $e');
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      await sessionBox.delete(_sessionKey);
    } catch (e) {
      throw CacheException('Failed to clear session: $e');
    }
  }
}
