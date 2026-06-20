import 'package:hive/hive.dart';

import 'package:dog_breed_app/core/error/exceptions.dart';

abstract class ThemeLocalDataSource {
  Future<String?> getThemePreference();

  Future<void> setThemePreference(String mode);
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  final Box settingsBox;

  static const String _themeKey = 'theme_mode';

  ThemeLocalDataSourceImpl({required this.settingsBox});

  @override
  Future<String?> getThemePreference() async {
    try {
      final value = settingsBox.get(_themeKey);
      if (value == null) return null;
      return value as String;
    } catch (e) {
      throw CacheException('Failed to get theme preference: $e');
    }
  }

  @override
  Future<void> setThemePreference(String mode) async {
    try {
      await settingsBox.put(_themeKey, mode);
    } catch (e) {
      throw CacheException('Failed to set theme preference: $e');
    }
  }
}
