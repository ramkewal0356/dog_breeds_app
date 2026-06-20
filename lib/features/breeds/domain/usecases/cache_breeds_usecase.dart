import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/breed_entity.dart';
import '../repositories/breed_repository.dart';

class CacheBreedsUseCase {
  final BreedRepository repository;

  CacheBreedsUseCase(this.repository);

  Future<Either<Failure, void>> call(List<BreedEntity> breeds) {
    return repository.cacheBreeds(breeds);
  }
}
