import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/paginated_breed_response.dart';

abstract class BreedRemoteDataSource {
  Future<PaginatedBreedResponse> getBreeds({
    required int page,
    required int pageSize,
  });
}

class BreedRemoteDataSourceImpl implements BreedRemoteDataSource {
  final Dio dio;

  BreedRemoteDataSourceImpl({required this.dio});

  @override
  Future<PaginatedBreedResponse> getBreeds({
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await dio.get(
        '/breeds',
        queryParameters: {'page[number]': page, 'page[size]': pageSize},
      );

      if (response.statusCode != null && response.statusCode! >= 500) {
        throw ServerException(
          statusCode: response.statusCode!,
          message: 'Server error: ${response.statusCode}',
        );
      }

      final data = response.data as Map<String, dynamic>;
      return PaginatedBreedResponse.fromJsonApi(data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkException();
      }

      if (e.response != null &&
          e.response!.statusCode != null &&
          e.response!.statusCode! >= 500) {
        throw ServerException(
          statusCode: e.response!.statusCode!,
          message: 'Server error: ${e.response!.statusCode}',
        );
      }

      throw const NetworkException();
    } on ServerException {
      rethrow;
    } on ParseException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Failed to parse breed API response: $e');
    }
  }
}
