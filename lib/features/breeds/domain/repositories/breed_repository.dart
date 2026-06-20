import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/breed_entity.dart';
import '../entities/paginated_result.dart';

/// Abstract repository interface for breed data operations.
/// Implemented in the Data layer; the Domain layer depends only on this contract.
abstract class BreedRepository {
  /// Fetches a paginated list of breeds from the remote API.
  /// Returns [PaginatedResult] on success or [Failure] on error.
  Future<Either<Failure, PaginatedResult<BreedEntity>>> getBreeds({
    required int page,
    required int pageSize,
  });

  Future<Either<Failure, List<BreedEntity>>> getCachedBreeds();

  Future<Either<Failure, void>> cacheBreeds(List<BreedEntity> breeds);

  Future<Either<Failure, void>> clearCache();
}
