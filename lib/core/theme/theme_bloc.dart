import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dog_breed_app/core/theme/theme_repository.dart';

// --- Events ---

/// Base class for all theme events.
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load the persisted theme preference on app startup.
class LoadThemeEvent extends ThemeEvent {
  const LoadThemeEvent();
}

/// Event to toggle the theme between light and dark.
class ToggleThemeEvent extends ThemeEvent {
  const ToggleThemeEvent();
}

// --- States ---

/// Base class for all theme states.
abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object?> get props => [];
}

/// State emitted when the theme has been loaded or changed.
class ThemeLoaded extends ThemeState {
  final ThemeMode mode;

  const ThemeLoaded(this.mode);

  @override
  List<Object?> get props => [mode];
}

// --- Bloc ---

/// Bloc that manages the application's theme state.
///
/// Handles:
/// - [LoadThemeEvent]: Loads the persisted theme preference from storage.
/// - [ToggleThemeEvent]: Toggles between light and dark themes.
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository themeRepository;

  ThemeBloc({required this.themeRepository})
      : super(const ThemeLoaded(ThemeMode.system)) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
  }

  /// Loads the theme preference from the repository.
  /// Emits [ThemeLoaded] with the stored mode, defaulting to [ThemeMode.system].
  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final result = await themeRepository.getThemePreference();

    result.fold(
      (_) => emit(const ThemeLoaded(ThemeMode.system)),
      (mode) => emit(ThemeLoaded(mode)),
    );
  }

  /// Toggles the theme between light and dark.
  /// Persists the new preference to storage.
  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final currentState = state;
    if (currentState is ThemeLoaded) {
      final newMode = currentState.mode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;

      await themeRepository.setThemePreference(newMode);
      emit(ThemeLoaded(newMode));
    }
  }
}
