import 'dart:async';

import 'package:dog_breed_app/core/constants/no_internet_widget.dart';
import 'package:dog_breed_app/features/breeds/presentation/widgets/filter_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/connectivity_service.dart';
import '../../../../injection.dart';
import '../../domain/entities/breed_entity.dart';
import '../bloc/breeds_bloc.dart';
import '../bloc/breeds_event.dart';
import '../bloc/breeds_state.dart';
import 'breed_card.dart';
import 'breed_search_bar.dart';

class BreedListWidget extends StatefulWidget {
  const BreedListWidget({super.key});

  @override
  State<BreedListWidget> createState() => _BreedListWidgetState();
}

class _BreedListWidgetState extends State<BreedListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    context.read<BreedsBloc>().add(const FetchBreedsEvent());
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isNearBottom) {
      context.read<BreedsBloc>().add(const FetchNextPageEvent());
    }
  }

  bool get _isNearBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= maxScroll - 200;
  }

  Future<void> _onRefresh() async {
    setState(() {
      _searchController.clear();
    });
    FocusManager.instance.primaryFocus?.unfocus();

    context.read<BreedsBloc>().add(const ClearSearchEvent());
    context.read<BreedsBloc>().add(const FetchBreedsEvent());

    context.read<BreedsBloc>().add(const RefreshBreedsEvent());

    // Clear search results
    context.read<BreedsBloc>().add(const ClearSearchEvent());
    // Wait for the bloc to emit a non-loading state
    await context.read<BreedsBloc>().stream.firstWhere(
      (state) => state is! BreedsLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BreedSearchBar(controller: _searchController),
        BreedFilterTabBar(),
        Expanded(
          child: ValueListenableBuilder<bool>(
            valueListenable: sl<ConnectivityService>().isConnectedNotifier,
            builder: (context, isConnected, _) {
              if (!isConnected) {
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .7,
                        child: const NoInternetWidget(),
                      ),
                    ],
                  ),
                );
              }
              return BlocBuilder<BreedsBloc, BreedsState>(
                builder: (context, state) {
                  if (state is BreedsLoading) {
                    return const _LoadingWidget();
                  }

                  if (state is BreedsEmpty) {
                    return RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: const _EmptyStateWidget(),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is BreedsError) {
                    return RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: _ErrorWidget(
                        message: state.message,
                        onRetry: () {
                          context.read<BreedsBloc>().add(
                            const FetchBreedsEvent(),
                          );
                        },
                      ),
                    );
                  }

                  if (state is BreedsLoaded) {
                    return _buildBreedList(state.breeds, state.hasMore);
                  }

                  if (state is BreedsLoadingMore) {
                    return _buildBreedList(
                      state.currentBreeds,
                      true,
                      isLoadingMore: true,
                    );
                  }

                  return const SizedBox.shrink();
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBreedList(
    List<BreedEntity> breeds,
    bool hasMore, {
    bool isLoadingMore = false,
  }) {
    if (breeds.isEmpty) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: const _EmptySearchResultWidget(),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: breeds.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == breeds.length) {
            return const _BottomLoadingIndicator();
          }
          return BreedCard(breed: breeds[index]);
        },
      ),
    );
  }
}

/// Loading indicator displayed during initial breed fetch.
class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

/// Displayed when the breed list from the API is empty.
class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pets,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No breeds available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Displayed when a search query produces zero results.
class _EmptySearchResultWidget extends StatelessWidget {
  const _EmptySearchResultWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No breeds found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Error state with a message and retry button.
class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Loading indicator shown at the bottom of the list during pagination.
class _BottomLoadingIndicator extends StatelessWidget {
  const _BottomLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
