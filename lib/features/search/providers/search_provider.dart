import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trovemart_app/core/mock/mock_data.dart';
import 'package:trovemart_app/features/products/models/product.dart';

/// Search state notifier.
///
/// Manages search query, results, history, and suggestions.
class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(const SearchState()) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    // In production, load from local storage
    // For mock, start empty
    state = state.copyWith(history: const []);
  }

  /// Update search query and trigger search.
  void setQuery(String query) {
    state = state.copyWith(query: query);
    if (query.trim().isNotEmpty) {
      _performSearch(query);
    } else {
      state = state.copyWith(results: const [], suggestions: _getSuggestions(query));
    }
  }

  /// Perform search with current query.
  Future<void> _performSearch(String query) async {
    state = state.copyWith(isSearching: true);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    final allProducts = MockData.products;
    final lowercaseQuery = query.toLowerCase();

    final results = allProducts.where((product) {
      return product.name.toLowerCase().contains(lowercaseQuery) ||
          product.brand.toLowerCase().contains(lowercaseQuery) ||
          product.description.toLowerCase().contains(lowercaseQuery) ||
          product.categoryId.toLowerCase().contains(lowercaseQuery);
    }).toList();

    state = state.copyWith(
      isSearching: false,
      results: results,
      suggestions: _getSuggestions(query),
    );
  }

  /// Get search suggestions based on query.
  List<String> _getSuggestions(String query) {
    if (query.trim().isEmpty) return const [];

    final allProducts = MockData.products;
    final lowercaseQuery = query.toLowerCase();

    final suggestions = <String>{};

    for (final product in allProducts) {
      if (product.name.toLowerCase().contains(lowercaseQuery)) {
        suggestions.add(product.name);
      }
      if (product.brand.toLowerCase().contains(lowercaseQuery)) {
        suggestions.add(product.brand);
      }
    }

    return suggestions.take(5).toList();
  }

  /// Add query to search history.
  void addToHistory(String query) {
    if (query.trim().isEmpty) return;

    final newHistory = [
      query,
      ...state.history.where((h) => h != query),
    ].take(10).toList();

    state = state.copyWith(history: newHistory);
    // TODO: Persist to local storage
  }

  /// Clear search history.
  void clearHistory() {
    state = state.copyWith(history: const []);
    // TODO: Clear from local storage
  }

  /// Clear current search.
  void clearSearch() {
    state = state.copyWith(query: '', results: const [], suggestions: const []);
  }

  /// Select a suggestion and search for it.
  void selectSuggestion(String suggestion) {
    setQuery(suggestion);
    addToHistory(suggestion);
  }

  /// Select a history item and search for it.
  void selectHistoryItem(String item) {
    setQuery(item);
  }
}

/// Search feature state.
class SearchState {
  final String query;
  final List<Product> results;
  final List<String> suggestions;
  final List<String> history;
  final bool isSearching;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.suggestions = const [],
    this.history = const [],
    this.isSearching = false,
  });

  SearchState copyWith({
    String? query,
    List<Product>? results,
    List<String>? suggestions,
    List<String>? history,
    bool? isSearching,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      suggestions: suggestions ?? this.suggestions,
      history: history ?? this.history,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

/// Provider for search state.
final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier();
});

/// Provider for search query (derived).
final searchQueryProvider = Provider<String>((ref) {
  return ref.watch(searchProvider).query;
});

/// Provider for search results (derived).
final searchResultsProvider = Provider<List<Product>>((ref) {
  return ref.watch(searchProvider).results;
});

/// Provider for search suggestions (derived).
final searchSuggestionsProvider = Provider<List<String>>((ref) {
  return ref.watch(searchProvider).suggestions;
});

/// Provider for search history (derived).
final searchHistoryProvider = Provider<List<String>>((ref) {
  return ref.watch(searchProvider).history;
});

/// Provider for search loading state (derived).
final searchLoadingProvider = Provider<bool>((ref) {
  return ref.watch(searchProvider).isSearching;
});