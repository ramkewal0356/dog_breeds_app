import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String username, String password);

  Future<Either<Failure, UserEntity>> register(
    String username,
    String password,
  );

  Future<Either<Failure, UserEntity?>> getSession();

  Future<Either<Failure, void>> logout();
}
