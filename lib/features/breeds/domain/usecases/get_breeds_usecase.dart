import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../entities/breed_entity.dart';
import '../entities/paginated_result.dart';
import '../repositories/breed_repository.dart';

class GetBreedsUseCase {
  final BreedRepository repository;

  GetBreedsUseCase(this.repository);

  Future<Either<Failure, PaginatedResult<BreedEntity>>> call(
    GetBreedsParams params,
  ) {
    return repository.getBreeds(page: params.page, pageSize: params.pageSize);
  }
}

/// Parameters required for the get breeds use case.
class GetBreedsParams extends Equatable {
  final int page;
  final int pageSize;

  const GetBreedsParams({required this.page, this.pageSize = 10});

  @override
  List<Object?> get props => [page, pageSize];
}
