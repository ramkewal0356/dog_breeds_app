import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:dog_breed_app/core/error/failures.dart';

/// Abstract repository interface for theme preference operations.
///
/// Provides methods to get and set the user's theme preference.
/// Implemented in [ThemeRepositoryImpl].
abstract class ThemeRepository {
  /// Retrieves the user's persisted theme preference.
  /// Returns [ThemeMode.system] if no preference has been stored.
  Future<Either<Failure, ThemeMode>> getThemePreference();

  /// Persists the given [mode] as the user's theme preference.
  Future<Either<Failure, void>> setThemePreference(ThemeMode mode);
}
