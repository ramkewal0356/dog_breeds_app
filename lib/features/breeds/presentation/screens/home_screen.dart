import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dog_breed_app/core/theme/theme_bloc.dart';
import 'package:dog_breed_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dog_breed_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:dog_breed_app/features/auth/presentation/bloc/auth_state.dart';
import '../../../../core/constants/alert_dailog.dart';
import '../widgets/breed_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final username = state is AuthAuthenticated
                  ? state.user.username
                  : '';
              return Text(
                'Hi, $username',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              );
            },
          ),
          actions: [
            // Theme toggle button
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                final isDark =
                    state is ThemeLoaded && state.mode == ThemeMode.dark;
                return IconButton(
                  key: const Key('theme_toggle_button'),
                  icon: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  tooltip: isDark
                      ? 'Switch to light mode'
                      : 'Switch to dark mode',
                  onPressed: () {
                    context.read<ThemeBloc>().add(const ToggleThemeEvent());
                  },
                );
              },
            ),
            // Logout button
            IconButton(
              key: const Key('logout_button'),
              icon: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              tooltip: 'Logout',
              onPressed: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
        body: const BreedListWidget(),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (_) => const LogoutDialog(),
    );

    if (shouldLogout == true && context.mounted) {
      context.read<AuthBloc>().add(const LogoutEvent());
    }
  }
}
