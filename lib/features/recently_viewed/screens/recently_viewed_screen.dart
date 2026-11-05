import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trovemart_app/core/routing/app_router.dart';
import 'package:trovemart_app/core/shared_widgets/tm_button.dart';
import 'package:trovemart_app/core/shared_widgets/tm_product_card.dart';
import 'package:trovemart_app/features/recently_viewed/providers/recently_viewed_provider.dart';
import 'package:trovemart_app/features/wishlist/providers/wishlist_provider.dart';

/// Recently viewed products screen (Section 16).
class RecentlyViewedScreen extends ConsumerWidget {
  const RecentlyViewedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyViewed = ref.watch(recentlyViewedProvider);
    final wishlistIds = ref.watch(wishlistIdsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Recently viewed (${recentlyViewed.length})'),
        centerTitle: false,
        actions: [
          if (recentlyViewed.isNotEmpty)
            TextButton(
              onPressed: () =>
                  ref.read(recentlyViewedProvider.notifier).clear(),
              child: const Text('Clear all'),
            ),
        ],
      ),
      body: recentlyViewed.isEmpty
          ? _buildEmptyState(context)
          : RefreshIndicator(
              onRefresh: () async {},
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: recentlyViewed.length,
                itemBuilder: (context, index) {
                  final product = recentlyViewed[index];
                  return TmProductCard(
                    product: product,
                    isInWishlist: wishlistIds.contains(product.id),
                    onWishlistToggle: () =>
                        ref.read(wishlistProvider.notifier).toggle(product),
                    onAddToCart: () {
                      // TODO: Wire to cart provider (Phase 9)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to cart'),
                        ),
                      );
                    },
                    onTap: () => Navigator.of(context).pushNamed(
                      AppRoutes.productDetail,
                      arguments: product.id,
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No recently viewed products',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Products you view will appear here so you can easily find them again.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TmButton(
              text: 'Start shopping',
              variant: TmButtonVariant.primary,
              onPressed: () =>
                  Navigator.of(context).popUntil(ModalRoute.withName('/')),
            ),
          ],
        ),
      ),
    );
  }
}