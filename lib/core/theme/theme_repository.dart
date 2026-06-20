import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:dog_breed_app/core/error/failures.dart';

abstract class ThemeRepository {
  Future<Either<Failure, ThemeMode>> getThemePreference();

  /// Persists the given [mode] as the user's theme preference.
  Future<Either<Failure, void>> setThemePreference(ThemeMode mode);
}
