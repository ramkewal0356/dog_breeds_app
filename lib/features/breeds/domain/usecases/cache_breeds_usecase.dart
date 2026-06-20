import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/breed_entity.dart';
import '../repositories/breed_repository.dart';

/// Use case that stores breeds in local cache.
///
/// Used by the Breeds Bloc to persist fetched breed data locally
/// for offline access and cache-first loading strategy.
class CacheBreedsUseCase {
  final BreedRepository repository;

  CacheBreedsUseCase(this.repository);

  /// Executes the cache breeds use case with the given [breeds].
  /// Returns void on success or a [Failure] on error.
  Future<Either<Failure, void>> call(List<BreedEntity> breeds) {
    return repository.cacheBreeds(breeds);
  }
}
