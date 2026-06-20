import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/breed_entity.dart';
import '../repositories/breed_repository.dart';

/// Use case that retrieves cached breeds from local storage.
///
/// Used by the Breeds Bloc to load previously fetched breed data
/// when offline or as part of the cache-first loading strategy.
class GetCachedBreedsUseCase {
  final BreedRepository repository;

  GetCachedBreedsUseCase(this.repository);

  /// Executes the get cached breeds use case.
  /// Returns a list of [BreedEntity] on success or a [Failure] on error.
  Future<Either<Failure, List<BreedEntity>>> call() {
    return repository.getCachedBreeds();
  }
}
