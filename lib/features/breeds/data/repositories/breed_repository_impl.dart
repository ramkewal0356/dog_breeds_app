import 'package:dartz/dartz.dart';
import 'package:dog_breed_app/core/network/connectivity_repository.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/breed_entity.dart';
import '../../domain/entities/paginated_result.dart';
import '../../domain/repositories/breed_repository.dart';
import '../datasources/breed_local_data_source.dart';
import '../datasources/breed_remote_data_source.dart';
import '../models/breed_model.dart';

class BreedRepositoryImpl implements BreedRepository {
  final BreedRemoteDataSource remoteDataSource;
  final BreedLocalDataSource localDataSource;
  final ConnectivityRepository connectivityRepository;

  BreedRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivityRepository,
  });

  @override
  Future<Either<Failure, PaginatedResult<BreedEntity>>> getBreeds({
    required int page,
    required int pageSize,
  }) async {
    try {
      if (!await connectivityRepository.isConnected) {
        return const Left(NetworkFailure());
      }
      final response = await remoteDataSource.getBreeds(
        page: page,
        pageSize: pageSize,
      );

      final entities = response.breeds
          .map((model) => model.toEntity())
          .toList();

      // Cache results on successful fetch
      try {
        await localDataSource.cacheBreeds(response.breeds);
      } catch (_) {
        // Cache failure should not prevent returning successful data
      }

      return Right(
        PaginatedResult<BreedEntity>(
          items: entities,
          currentPage: response.currentPage,
          totalPages: response.totalPages,
          hasNextPage: response.hasNextPage,
        ),
      );
    } on NetworkException {
      return _fallbackToCacheOrFail(const NetworkFailure());
    } on ServerException catch (e) {
      return _fallbackToCacheOrFail(
        ServerFailure(statusCode: e.statusCode, message: e.message),
      );
    } on ParseException catch (e) {
      return Left(ParseFailure(e.message));
    }
  }

  /// Attempts to return cached data as fallback.
  /// If cache also fails, returns the original network failure.
  Future<Either<Failure, PaginatedResult<BreedEntity>>> _fallbackToCacheOrFail(
    Failure originalFailure,
  ) async {
    try {
      final cachedModels = await localDataSource.getCachedBreeds();
      if (cachedModels.isEmpty) {
        return Left(originalFailure);
      }
      final entities = cachedModels.map((model) => model.toEntity()).toList();
      return Right(
        PaginatedResult<BreedEntity>(
          items: entities,
          currentPage: 1,
          totalPages: 1,
          hasNextPage: false,
        ),
      );
    } on CacheException {
      return Left(originalFailure);
    }
  }

  @override
  Future<Either<Failure, List<BreedEntity>>> getCachedBreeds() async {
    try {
      final cachedModels = await localDataSource.getCachedBreeds();
      final entities = cachedModels.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> cacheBreeds(List<BreedEntity> breeds) async {
    try {
      final models = breeds
          .map((entity) => BreedModel.fromEntity(entity))
          .toList();
      await localDataSource.cacheBreeds(models);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await localDataSource.clearBreeds();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
