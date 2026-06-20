import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/breed_entity.dart';
import '../entities/paginated_result.dart';

abstract class BreedRepository {
  Future<Either<Failure, PaginatedResult<BreedEntity>>> getBreeds({
    required int page,
    required int pageSize,
  });

  Future<Either<Failure, List<BreedEntity>>> getCachedBreeds();

  Future<Either<Failure, void>> cacheBreeds(List<BreedEntity> breeds);

  Future<Either<Failure, void>> clearCache();
}
