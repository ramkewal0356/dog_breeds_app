import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:dog_breed_app/core/error/exceptions.dart';
import 'package:dog_breed_app/core/error/failures.dart';
import 'package:dog_breed_app/core/theme/theme_local_data_source.dart';
import 'package:dog_breed_app/core/theme/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  ThemeRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, ThemeMode>> getThemePreference() async {
    try {
      final modeString = await localDataSource.getThemePreference();
      final mode = _themeModeFromString(modeString);
      return Right(mode);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> setThemePreference(ThemeMode mode) async {
    try {
      final modeString = _themeModeToString(mode);
      await localDataSource.setThemePreference(modeString);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  /// Converts a stored string value to a [ThemeMode].
  /// Returns [ThemeMode.system] if the value is null or unrecognized.
  ThemeMode _themeModeFromString(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  /// Converts a [ThemeMode] to its string representation for storage.
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
