import 'package:dartz/dartz.dart';

import '../../../../core/utils/base_eport.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final PasswordHasher passwordHasher;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.passwordHasher,
  });

  @override
  Future<Either<Failure, UserEntity>> login(
    String username,
    String password,
  ) async {
    try {
      final hashedPassword = passwordHasher.hash(password);

      final existingUser = await localDataSource.getUser(username);

      if (existingUser != null) {
        if (existingUser.passwordHash != hashedPassword) {
          return const Left(AuthFailure('Invalid email or password'));
        }

        await localDataSource.saveSession(existingUser);

        return Right(
          UserEntity(
            passwordHash: existingUser.passwordHash,
            username: existingUser.username,
            isNewUser: false,
          ),
        );
      }

      final newUser = UserModel(
        username: username,
        passwordHash: hashedPassword,
      );

      await localDataSource.saveUser(newUser);
      await localDataSource.saveSession(newUser);

      return Right(
        UserEntity(
          passwordHash: newUser.passwordHash,
          username: newUser.username,
          isNewUser: true,
        ),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
    String username,
    String password,
  ) async {
    try {
      final hashedPassword = passwordHasher.hash(password);

      final newUser = UserModel(
        username: username,
        passwordHash: hashedPassword,
      );

      await localDataSource.saveUser(newUser);
      await localDataSource.saveSession(newUser);

      return Right(
        UserEntity(
          passwordHash: newUser.passwordHash,
          username: newUser.username,
          isNewUser: true,
        ),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getSession() async {
    try {
      final session = await localDataSource.getSession();

      if (session == null) {
        return const Right(null);
      }

      return Right(
        UserEntity(
          passwordHash: session.passwordHash,
          username: session.username,
          isNewUser: false,
        ),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearSession();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
