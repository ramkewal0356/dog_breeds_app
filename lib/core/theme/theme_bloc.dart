import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dog_breed_app/core/theme/theme_repository.dart';

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

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository themeRepository;

  ThemeBloc({required this.themeRepository})
    : super(const ThemeLoaded(ThemeMode.system)) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
  }

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
