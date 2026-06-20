import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../entities/breed_entity.dart';
import '../entities/paginated_result.dart';
import '../repositories/breed_repository.dart';

/// Use case that fetches a paginated list of breeds from the remote API.
///
/// Used by the Breeds Bloc to load breed data with pagination support.
/// Each call fetches a specific page of results based on [GetBreedsParams].
class GetBreedsUseCase {
  final BreedRepository repository;

  GetBreedsUseCase(this.repository);

  /// Executes the get breeds use case with the given [params].
  /// Returns a [PaginatedResult] of [BreedEntity] on success or a [Failure] on error.
  Future<Either<Failure, PaginatedResult<BreedEntity>>> call(
      GetBreedsParams params) {
    return repository.getBreeds(
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}

/// Parameters required for the get breeds use case.
class GetBreedsParams extends Equatable {
  final int page;
  final int pageSize;

  const GetBreedsParams({
    required this.page,
    this.pageSize = 10,
  });

  @override
  List<Object?> get props => [page, pageSize];
}
