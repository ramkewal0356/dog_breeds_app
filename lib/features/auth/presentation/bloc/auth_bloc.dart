import 'package:dog_breed_app/core/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/check_session_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckSessionUseCase checkSessionUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.checkSessionUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
  }) : super(const AuthInitial()) {
    on<CheckSessionEvent>(_onCheckSession);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
  }

  /// Handles session check on app startup.
  /// Emits [AuthAuthenticated] if a session exists, [AuthUnauthenticated] otherwise.
  Future<void> _onCheckSession(
    CheckSessionEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await checkSessionUseCase();

    result.fold((failure) => emit(AuthError(failure.message)), (user) {
      if (user != null) {
        emit(AuthAuthenticated(user: user, isNewUser: false));
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    final emailError = Validators.validateEmail(event.username.trim());

    final passwordError = Validators.validatePassword(event.password.trim());

    // Stop login if form validation fails
    if (emailError != null || passwordError != null) {
      return;
    }

    emit(const AuthLoading());

    final result = await loginUseCase(
      LoginParams(
        username: event.username.trim(),
        password: event.password.trim(),
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user: user, isNewUser: user.isNewUser)),
    );
  }

  /// Handles logout.
  /// Calls the logout use case and emits [AuthUnauthenticated].
  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    final result = await logoutUseCase();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }
}
