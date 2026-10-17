import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/search_hit.dart';
import 'catalog_stats_provider.dart';

class HomeSearchState {
  final String query;
  final bool isLoading;
  final GroupedSearchResults results;

  const HomeSearchState({
    this.query = '',
    this.isLoading = false,
    this.results = const GroupedSearchResults(),
  });

  HomeSearchState copyWith({
    String? query,
    bool? isLoading,
    GroupedSearchResults? results,
  }) {
    return HomeSearchState(
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      results: results ?? this.results,
    );
  }
}

class HomeSearchNotifier extends Notifier<HomeSearchState> {
  Timer? _debounceTimer;

  @override
  HomeSearchState build() {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });
    return const HomeSearchState();
  }

  void onQueryChanged(String query) {
    state = state.copyWith(query: query);
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      state = state.copyWith(
        isLoading: false,
        results: const GroupedSearchResults(),
      );
      return;
    }

    state = state.copyWith(isLoading: true);
    // AC-2: 150ms debounce
    _debounceTimer = Timer(const Duration(milliseconds: 150), () async {
      final repo = ref.read(homeRepositoryProvider);
      final results = await repo.search(query);
      if (state.query == query) {
        state = state.copyWith(
          isLoading: false,
          results: results,
        );
      }
    });
  }

  void clearQuery() {
    _debounceTimer?.cancel();
    state = const HomeSearchState();
  }
}

final homeSearchProvider =
    NotifierProvider<HomeSearchNotifier, HomeSearchState>(HomeSearchNotifier.new);
