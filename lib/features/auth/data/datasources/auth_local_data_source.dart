import 'package:hive/hive.dart';

import 'package:dog_breed_app/core/error/exceptions.dart';
import 'package:dog_breed_app/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getUser(String username);

  Future<void> saveUser(UserModel user);

  Future<UserModel?> getSession();

  Future<void> saveSession(UserModel user);

  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<Map> usersBox;
  final Box<Map> sessionBox;

  static const String _sessionKey = 'current_user';

  AuthLocalDataSourceImpl({required this.usersBox, required this.sessionBox});

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
