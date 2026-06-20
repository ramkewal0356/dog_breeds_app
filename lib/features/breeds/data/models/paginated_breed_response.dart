import 'package:equatable/equatable.dart';

import '../../../../core/error/exceptions.dart';
import 'breed_model.dart';

/// Represents a paginated response from the Dog Breeds API.
/// Parses the full JSON:API response including data, links, and meta.
class PaginatedBreedResponse extends Equatable {
  final List<BreedModel> breeds;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;

  const PaginatedBreedResponse({
    required this.breeds,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
  });

  /// Creates a PaginatedBreedResponse from the full JSON:API response.
  ///
  /// Expects the format:
  /// ```json
  /// {
  ///   "data": [ ... ],
  ///   "links": { "current": "...", "next": "...", "last": "..." },
  ///   "meta": {
  ///     "pagination": {
  ///       "current_page": 1,
  ///       "total_pages": 7
  ///     }
  ///   }
  /// }
  /// ```
  factory PaginatedBreedResponse.fromJsonApi(Map<String, dynamic> json) {
    try {
      // Parse breed data array
      final dataList = json['data'] as List<dynamic>? ?? [];
      final breeds = dataList
          .map((item) =>
              BreedModel.fromJsonApi(item as Map<String, dynamic>))
          .toList();

      // Parse pagination metadata
      final meta = json['meta'] as Map<String, dynamic>? ?? <String, dynamic>{};
      final pagination =
          meta['pagination'] as Map<String, dynamic>? ?? <String, dynamic>{};
      final currentPage = (pagination['current_page'] as num?)?.toInt() ?? 1;
      final totalPages = (pagination['total_pages'] as num?)?.toInt() ?? 1;

      // Determine if there's a next page from links or page numbers
      final links =
          json['links'] as Map<String, dynamic>? ?? <String, dynamic>{};
      final hasNextPage = links['next'] != null || currentPage < totalPages;

      return PaginatedBreedResponse(
        breeds: breeds,
        currentPage: currentPage,
        totalPages: totalPages,
        hasNextPage: hasNextPage,
      );
    } catch (e) {
      if (e is ParseException) rethrow;
      throw ParseException('Failed to parse paginated breed response: $e');
    }
  }

  @override
  List<Object?> get props => [breeds, currentPage, totalPages, hasNextPage];
}
