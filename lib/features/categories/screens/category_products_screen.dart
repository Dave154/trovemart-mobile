import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trovemart_app/core/shared_widgets/tm_product_card.dart';
import 'package:trovemart_app/core/shared_widgets/tm_loading.dart';
import 'package:trovemart_app/core/shared_widgets/tm_error_state.dart';
import 'package:trovemart_app/features/categories/models/category.dart';
import 'package:trovemart_app/features/categories/providers/category_provider.dart';
import 'package:trovemart_app/features/products/models/product.dart';
import 'package:trovemart_app/features/recently_viewed/providers/recently_viewed_provider.dart';

/// Screen displaying products within a specific category.
class CategoryProductsScreen extends ConsumerWidget {
  const CategoryProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)?.settings.arguments as Category?;
    final category = args ??
        (ref.watch(selectedCategoryIdProvider) != null
            ? ref
                .watch(categoriesProvider)
                .firstWhere((c) => c.id == ref.watch(selectedCategoryIdProvider))
            : null);

    if (category == null) {
      return const _CategoryNotFoundScreen();
    }

    final products = ref.watch(categoryProductsProvider);
    final isLoading = ref.watch(categoryProductsLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        centerTitle: false,
      ),
      body: _buildBody(context, ref, category, products, isLoading),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    Category category,
    List<Product> products,
    bool isLoading,
  ) {
    if (isLoading) {
      return const TmLoadingPage(message: 'Loading products...');
    }

    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'No products in this category',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Check back later for new arrivals.',
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

    return RefreshIndicator(
      onRefresh: () async =>
          ref.read(categoryProvider.notifier).loadCategoryProducts(category.id),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return TmProductCard(
            product: product,
            isInWishlist: false,
            onWishlistToggle: () {
              // TODO: Wire to wishlist provider (Phase 8)
            },
            onAddToCart: () {
              // TODO: Wire to cart provider (Phase 9)
            },
            onTap: () => _navigateToProductDetail(context, ref, product),
          );
        },
      ),
    );
  }

  void _navigateToProductDetail(
    BuildContext context,
    WidgetRef ref,
    Product product,
  ) {
    // Add to recently viewed
    ref.read(recentlyViewedProvider.notifier).add(product);

    Navigator.of(context).pushNamed(
      '/product-detail',
      arguments: product.id,
    );
  }
}

/// Fallback screen when category argument is missing.
class _CategoryNotFoundScreen extends StatelessWidget {
  const _CategoryNotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Category')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.category_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'Category not found',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'The requested category could not be loaded.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}