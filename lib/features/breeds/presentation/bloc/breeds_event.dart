import 'package:equatable/equatable.dart';

/// Base class for all breeds-related events.
abstract class BreedsEvent extends Equatable {
  const BreedsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch the initial list of breeds (cache-first + network refresh).
class FetchBreedsEvent extends BreedsEvent {
  const FetchBreedsEvent();
}

/// Event to fetch the next page of breeds (pagination).
class FetchNextPageEvent extends BreedsEvent {
  const FetchNextPageEvent();
}

/// Event to refresh the breed list (pull-to-refresh).
class RefreshBreedsEvent extends BreedsEvent {
  const RefreshBreedsEvent();
}

/// Event to filter breeds by a search query (case-insensitive name match).
class SearchBreedsEvent extends BreedsEvent {
  final String query;

  const SearchBreedsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterBreedsByTabEvent extends BreedsEvent {
  final int tabIndex;

  const FilterBreedsByTabEvent(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

/// Event to clear the search filter and restore the full breed list.
class ClearSearchEvent extends BreedsEvent {
  const ClearSearchEvent();
}
