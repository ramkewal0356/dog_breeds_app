import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/breed_entity.dart';
import '../repositories/breed_repository.dart';

class GetCachedBreedsUseCase {
  final BreedRepository repository;

  GetCachedBreedsUseCase(this.repository);

  Future<Either<Failure, List<BreedEntity>>> call() {
    return repository.getCachedBreeds();
  }
}
