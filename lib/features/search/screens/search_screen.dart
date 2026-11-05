import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trovemart_app/core/shared_widgets/tm_product_card.dart';
import 'package:trovemart_app/core/shared_widgets/tm_loading.dart';
import 'package:trovemart_app/features/products/models/product.dart';
import 'package:trovemart_app/features/search/providers/search_provider.dart';
import 'package:trovemart_app/features/recently_viewed/providers/recently_viewed_provider.dart';

/// Search screen with query input, suggestions, history, and results.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(searchResultsProvider);
    final suggestions = ref.watch(searchSuggestionsProvider);
    final history = ref.watch(searchHistoryProvider);
    final isSearching = ref.watch(searchLoadingProvider);

    if (_controller.text != query) {
      _controller.text = query;
      _controller.selection = TextSelection.collapsed(offset: query.length);
    }

    return Scaffold(
      appBar: AppBar(
        title: _buildSearchField(context, ref, query),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: false,
      ),
      body: _buildBody(context, ref, query, results, suggestions, history, isSearching),
    );
  }

  Widget _buildSearchField(BuildContext context, WidgetRef ref, String query) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search products...',
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        border: InputBorder.none,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: query.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  ref.read(searchProvider.notifier).clearSearch();
                },
              )
            : null,
      ),
      onChanged: (value) => ref.read(searchProvider.notifier).setQuery(value),
      onSubmitted: (value) {
        if (value.trim().isNotEmpty) {
          ref.read(searchProvider.notifier).addToHistory(value);
        }
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    String query,
    List<Product> results,
    List<String> suggestions,
    List<String> history,
    bool isSearching,
  ) {
    if (query.isEmpty) {
      return _buildHistoryView(context, ref, history);
    }

    if (isSearching) {
      return const TmLoadingPage(message: 'Searching...');
    }

    if (results.isEmpty && suggestions.isEmpty) {
      return _buildEmptyResults(context, query);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (suggestions.isNotEmpty) ...[
          _buildSectionHeader('Suggestions'),
          const SizedBox(height: 8),
          _buildSuggestionsList(context, ref, suggestions),
          const SizedBox(height: 24),
        ],
        _buildSectionHeader('Results (${results.length})'),
        const SizedBox(height: 8),
        _buildResultsGrid(context, ref, results),
      ],
    );
  }

  Widget _buildHistoryView(BuildContext context, WidgetRef ref, List<String> history) {
    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Search for products',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Your recent searches will appear here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader('Recent Searches'),
            TextButton(
              onPressed: () => ref.read(searchProvider.notifier).clearHistory(),
              child: const Text('Clear all'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...history.map((item) => _buildHistoryTile(context, ref, item)),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _buildSuggestionsList(BuildContext context, WidgetRef ref, List<String> suggestions) {
    return Column(
      children: suggestions.map((suggestion) {
        return ListTile(
          leading: const Icon(Icons.search),
          title: Text(suggestion),
          onTap: () => ref.read(searchProvider.notifier).selectSuggestion(suggestion),
        );
      }).toList(),
    );
  }

  Widget _buildHistoryTile(BuildContext context, WidgetRef ref, String item) {
    return ListTile(
      leading: const Icon(Icons.history),
      title: Text(item),
      trailing: IconButton(
        icon: const Icon(Icons.close, size: 18),
        onPressed: () {},
      ),
      onTap: () => ref.read(searchProvider.notifier).selectHistoryItem(item),
    );
  }

  Widget _buildEmptyResults(BuildContext context, String query) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
              'No results for "$query"',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try different keywords or check spelling',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsGrid(BuildContext context, WidgetRef ref, List<Product> results) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return TmProductCard(
          product: product,
          isInWishlist: false,
          onWishlistToggle: () {},
          onAddToCart: () {},
          onTap: () {
            ref.read(recentlyViewedProvider.notifier).add(product);
            Navigator.of(context).pushNamed(
              '/product-detail',
              arguments: product.id,
            );
          },
        );
      },
    );
  }
}