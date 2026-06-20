import 'package:dog_breed_app/core/constants/custom_snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../injection.dart';
import '../../domain/entities/breed_entity.dart';
import '../../domain/usecases/cache_breeds_usecase.dart';
import '../../domain/usecases/get_breeds_usecase.dart';
import '../../domain/usecases/get_cached_breeds_usecase.dart';
import 'breeds_event.dart';
import 'breeds_state.dart';

class BreedsBloc extends Bloc<BreedsEvent, BreedsState> {
  final GetBreedsUseCase getBreedsUseCase;
  final GetCachedBreedsUseCase getCachedBreedsUseCase;
  final CacheBreedsUseCase cacheBreedsUseCase;

  /// The full unfiltered list of breeds loaded so far.
  List<BreedEntity> _allBreeds = [];

  /// The current page number for pagination.
  int _currentPage = 0;

  /// Whether more pages are available from the API.
  bool _hasMore = true;
  int _selectedTabIndex = 0;
  String _searchQuery = '';
  BreedsBloc({
    required this.getBreedsUseCase,
    required this.getCachedBreedsUseCase,
    required this.cacheBreedsUseCase,
  }) : super(const BreedsInitial()) {
    on<FetchBreedsEvent>(_onFetchBreeds);
    on<FetchNextPageEvent>(_onFetchNextPage);
    on<RefreshBreedsEvent>(_onRefreshBreeds);
    on<SearchBreedsEvent>(_onSearchBreeds);
    on<ClearSearchEvent>(_onClearSearch);
    on<FilterBreedsByTabEvent>(_onFilterBreedsByTab);
  }

  Future<void> _onFetchBreeds(
    FetchBreedsEvent event,
    Emitter<BreedsState> emit,
  ) async {
    emit(const BreedsLoading());

    final cachedResult = await getCachedBreedsUseCase();
    bool hasCachedData = false;

    cachedResult.fold(
      (failure) {
        emit(BreedsError(message: failure.message));
      },
      (cachedBreeds) {
        if (cachedBreeds.isNotEmpty) {
          hasCachedData = true;
          _allBreeds = cachedBreeds;

          _applyCurrentFilter(emit);
        }
      },
    );

    final result = await getBreedsUseCase(const GetBreedsParams(page: 1));

    result.fold(
      (failure) {
        if (!hasCachedData) {
          emit(BreedsError(message: failure.message));
        }
      },
      (paginatedResult) {
        if (paginatedResult.items.isEmpty && !hasCachedData) {
          emit(const BreedsEmpty());
          return;
        }

        _allBreeds = paginatedResult.items;
        _currentPage = paginatedResult.currentPage;
        _hasMore = paginatedResult.hasNextPage;

        cacheBreedsUseCase(_allBreeds);

        _applyCurrentFilter(emit);
      },
    );
  }

  Future<void> _onFetchNextPage(
    FetchNextPageEvent event,
    Emitter<BreedsState> emit,
  ) async {
    if (!_hasMore) return;

    if (state is! BreedsLoaded) return;
    final connected = await sl<ConnectivityService>().isConnected;

    if (!connected) {
      AppToast.showError("You're offline");
      return;
    }
    emit(BreedsLoadingMore(currentBreeds: _allBreeds));

    final result = await getBreedsUseCase(
      GetBreedsParams(page: _currentPage + 1),
    );

    result.fold(
      (failure) {
        emit(BreedsError(message: failure.message, hasCache: true));
      },
      (paginatedResult) {
        _allBreeds = [..._allBreeds, ...paginatedResult.items];

        _currentPage = paginatedResult.currentPage;
        _hasMore = paginatedResult.hasNextPage;

        _applyCurrentFilter(emit);
      },
    );
  }

  Future<void> _onRefreshBreeds(
    RefreshBreedsEvent event,
    Emitter<BreedsState> emit,
  ) async {
    final connected = await sl<ConnectivityService>().isConnected;

    if (!connected) {
      AppToast.showError("You're offline");

      if (_allBreeds.isNotEmpty) {
        _applyCurrentFilter(emit);
      }

      return;
    }
    final result = await getBreedsUseCase(const GetBreedsParams(page: 1));

    result.fold(
      (failure) {
        emit(
          BreedsError(
            message: failure.message,
            hasCache: _allBreeds.isNotEmpty,
          ),
        );
      },
      (paginatedResult) {
        _allBreeds = paginatedResult.items;
        _currentPage = paginatedResult.currentPage;
        _hasMore = paginatedResult.hasNextPage;

        cacheBreedsUseCase(_allBreeds);

        _applyCurrentFilter(emit);
      },
    );
  }

  Future<void> _onSearchBreeds(
    SearchBreedsEvent event,
    Emitter<BreedsState> emit,
  ) async {
    _searchQuery = event.query;
    _applyCurrentFilter(emit);
  }

  Future<void> _onFilterBreedsByTab(
    FilterBreedsByTabEvent event,
    Emitter<BreedsState> emit,
  ) async {
    _selectedTabIndex = event.tabIndex;
    _applyCurrentFilter(emit);
  }

  void _applyCurrentFilter(Emitter<BreedsState> emit) {
    List<BreedEntity> filteredBreeds = List.from(_allBreeds);

    switch (_selectedTabIndex) {
      case 1:
        // Hypoallergenic
        filteredBreeds = filteredBreeds
            .where((breed) => breed.hypoallergenic)
            .toList();
        break;

      case 2:
        // Small Dogs (<=10kg)
        filteredBreeds = filteredBreeds
            .where((breed) => breed.maleWeight.max <= 10)
            .toList();
        break;

      case 3:
        // Medium Dogs (11-25kg)
        filteredBreeds = filteredBreeds
            .where(
              (breed) =>
                  breed.maleWeight.max > 10 && breed.maleWeight.max <= 25,
            )
            .toList();
        break;

      case 4:
        // Large Dogs (>25kg)
        filteredBreeds = filteredBreeds
            .where((breed) => breed.maleWeight.max > 25)
            .toList();
        break;

      case 5:
        // Short Life (<15 years)
        filteredBreeds = filteredBreeds
            .where((breed) => breed.lifeSpan.max < 15)
            .toList();
        break;

      case 7:
        // A-Z
        filteredBreeds.sort((a, b) => a.name.compareTo(b.name));
        break;

      case 8:
        // Z-A
        filteredBreeds.sort((a, b) => b.name.compareTo(a.name));
        break;

      default:
        filteredBreeds = List.from(_allBreeds);
    }
    // SEARCH FILTER
    if (_searchQuery.isNotEmpty) {
      filteredBreeds = filteredBreeds.where((breed) {
        return breed.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            breed.lifeSpan.min.toString().contains(
              _searchQuery.toLowerCase(),
            ) ||
            breed.lifeSpan.max.toString().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    emit(
      BreedsLoaded(
        breeds: filteredBreeds,
        hasMore: _hasMore,
        searchQuery: _searchQuery,
      ),
    );
  }

  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<BreedsState> emit,
  ) async {
    _searchQuery = '';
    _applyCurrentFilter(emit);
  }
}
