import 'package:equatable/equatable.dart';

import '../../domain/entities/breed_entity.dart';

/// Base class for all breeds-related states.
abstract class BreedsState extends Equatable {
  const BreedsState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any breed data is loaded.
class BreedsInitial extends BreedsState {
  const BreedsInitial();
}

/// State while the initial breed list is being fetched.
class BreedsLoading extends BreedsState {
  const BreedsLoading();
}

/// State when breeds have been successfully loaded.
class BreedsLoaded extends BreedsState {
  final List<BreedEntity> breeds;
  final bool hasMore;
  final String searchQuery;

  const BreedsLoaded({
    required this.breeds,
    this.hasMore = true,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [breeds, hasMore, searchQuery];
}

/// State while an additional page of breeds is being loaded.
class BreedsLoadingMore extends BreedsState {
  final List<BreedEntity> currentBreeds;

  const BreedsLoadingMore({required this.currentBreeds});

  @override
  List<Object?> get props => [currentBreeds];
}

/// State when the breed list is empty (no breeds available).
class BreedsEmpty extends BreedsState {
  const BreedsEmpty();
}

/// State when an error occurs during breed data operations.
class BreedsError extends BreedsState {
  final String message;
  final bool hasCache;

  const BreedsError({
    required this.message,
    this.hasCache = false,
  });

  @override
  List<Object?> get props => [message, hasCache];
}
