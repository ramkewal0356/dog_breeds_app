import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:dog_breed_app/core/network/connectivity_repository.dart';
import 'package:dog_breed_app/core/network/connectivity_service.dart';
import 'package:dog_breed_app/core/theme/theme_bloc.dart';
import 'package:dog_breed_app/core/theme/theme_local_data_source.dart';
import 'package:dog_breed_app/core/theme/theme_repository.dart';
import 'package:dog_breed_app/core/theme/theme_repository_impl.dart';
import 'package:dog_breed_app/core/utils/password_hasher.dart';
import 'package:dog_breed_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:dog_breed_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dog_breed_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:dog_breed_app/features/auth/domain/usecases/check_session_usecase.dart';
import 'package:dog_breed_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:dog_breed_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:dog_breed_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dog_breed_app/features/breeds/data/datasources/breed_local_data_source.dart';
import 'package:dog_breed_app/features/breeds/data/datasources/breed_remote_data_source.dart';
import 'package:dog_breed_app/features/breeds/data/repositories/breed_repository_impl.dart';
import 'package:dog_breed_app/features/breeds/domain/repositories/breed_repository.dart';
import 'package:dog_breed_app/features/breeds/domain/usecases/cache_breeds_usecase.dart';
import 'package:dog_breed_app/features/breeds/domain/usecases/get_breeds_usecase.dart';
import 'package:dog_breed_app/features/breeds/domain/usecases/get_cached_breeds_usecase.dart';
import 'package:dog_breed_app/features/breeds/presentation/bloc/breeds_bloc.dart';

final sl = GetIt.instance;

Future<void> initHiveBoxes() async {
  await Hive.initFlutter();

  // Open all required boxes
  await Hive.openBox<Map>('users');
  await Hive.openBox<Map>('session');
  await Hive.openBox<Map>('breeds_cache');
  await Hive.openBox('settings');
}

Future<void> initDependencies() async {
  // ─── External Services ───────────────────────────────────────────────

  // Dio HTTP client
  sl.registerLazySingleton<Dio>(
    () => Dio(BaseOptions(baseUrl: 'https://dogapi.dog/api/v2')),
  );

  // Hive boxes (already opened by initHiveBoxes)
  sl.registerLazySingleton<Box<Map>>(
    () => Hive.box<Map>('users'),
    instanceName: 'usersBox',
  );
  sl.registerLazySingleton<Box<Map>>(
    () => Hive.box<Map>('session'),
    instanceName: 'sessionBox',
  );
  sl.registerLazySingleton<Box<Map>>(
    () => Hive.box<Map>('breeds_cache'),
    instanceName: 'breedsBox',
  );
  sl.registerLazySingleton<Box>(
    () => Hive.box('settings'),
    instanceName: 'settingsBox',
  );

  // ─── Core Services ──────────────────────────────────────────────────

  sl.registerLazySingleton<PasswordHasher>(() => PasswordHasher());

  sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  sl.registerLazySingleton<ConnectivityRepository>(
    () => sl<ConnectivityService>(),
  );

  // ─── Data Sources ───────────────────────────────────────────────────

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      usersBox: sl<Box<Map>>(instanceName: 'usersBox'),
      sessionBox: sl<Box<Map>>(instanceName: 'sessionBox'),
    ),
  );

  sl.registerLazySingleton<BreedRemoteDataSource>(
    () => BreedRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<BreedLocalDataSource>(
    () => BreedLocalDataSourceImpl(
      breedsBox: sl<Box<Map>>(instanceName: 'breedsBox'),
    ),
  );

  sl.registerLazySingleton<ThemeLocalDataSource>(
    () => ThemeLocalDataSourceImpl(
      settingsBox: sl<Box>(instanceName: 'settingsBox'),
    ),
  );

  // ─── Repositories ──────────────────────────────────────────────────

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDataSource: sl<AuthLocalDataSource>(),
      passwordHasher: sl<PasswordHasher>(),
    ),
  );

  sl.registerLazySingleton<BreedRepository>(
    () => BreedRepositoryImpl(
      remoteDataSource: sl<BreedRemoteDataSource>(),
      localDataSource: sl<BreedLocalDataSource>(),
      connectivityRepository: sl<ConnectivityRepository>(),
    ),
  );

  sl.registerLazySingleton<ThemeRepository>(
    () => ThemeRepositoryImpl(localDataSource: sl<ThemeLocalDataSource>()),
  );

  // ─── Use Cases ─────────────────────────────────────────────────────

  sl.registerFactory<LoginUseCase>(() => LoginUseCase(sl<AuthRepository>()));

  sl.registerFactory<CheckSessionUseCase>(
    () => CheckSessionUseCase(sl<AuthRepository>()),
  );

  sl.registerFactory<LogoutUseCase>(() => LogoutUseCase(sl<AuthRepository>()));

  sl.registerFactory<GetBreedsUseCase>(
    () => GetBreedsUseCase(sl<BreedRepository>()),
  );

  sl.registerFactory<GetCachedBreedsUseCase>(
    () => GetCachedBreedsUseCase(sl<BreedRepository>()),
  );

  sl.registerFactory<CacheBreedsUseCase>(
    () => CacheBreedsUseCase(sl<BreedRepository>()),
  );

  // ─── Blocs ─────────────────────────────────────────────────────────

  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      checkSessionUseCase: sl<CheckSessionUseCase>(),
      loginUseCase: sl<LoginUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
    ),
  );

  sl.registerFactory<BreedsBloc>(
    () => BreedsBloc(
      getBreedsUseCase: sl<GetBreedsUseCase>(),
      getCachedBreedsUseCase: sl<GetCachedBreedsUseCase>(),
      cacheBreedsUseCase: sl<CacheBreedsUseCase>(),
    ),
  );

  sl.registerFactory<ThemeBloc>(
    () => ThemeBloc(themeRepository: sl<ThemeRepository>()),
  );
}
