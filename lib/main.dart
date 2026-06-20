import 'package:dog_breed_app/core/constants/dismiss_keyboard.dart';

import 'core/utils/base_eport.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveBoxes();
  await initDependencies();
  runApp(const DogBreedsApp());
}

class DogBreedsApp extends StatelessWidget {
  const DogBreedsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<BreedsBloc>(create: (_) => sl<BreedsBloc>()),
        BlocProvider<ThemeBloc>(
          create: (_) => sl<ThemeBloc>()..add(const LoadThemeEvent()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          final themeMode = themeState is ThemeLoaded
              ? themeState.mode
              : ThemeMode.system;

          return MaterialApp(
            builder: (context, child) {
              return DismissKeyboard(child: child!);
            },
            title: 'Dog Breeds',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            debugShowCheckedModeBanner: false,
            initialRoute: '/splash',
            routes: {
              '/splash': (_) => const SplashScreen(),
              '/login': (_) => const LoginScreen(),
              '/home': (_) => const HomeScreen(),
            },
          );
        },
      ),
    );
  }
}
