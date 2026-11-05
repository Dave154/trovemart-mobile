import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trovemart_app/core/routing/app_router.dart';
import 'package:trovemart_app/core/shared_widgets/tm_button.dart';
import 'package:trovemart_app/core/shared_widgets/tm_product_card.dart';
import 'package:trovemart_app/features/recently_viewed/providers/recently_viewed_provider.dart';
import 'package:trovemart_app/features/wishlist/providers/wishlist_provider.dart';

/// Wishlist screen — displays all saved products (Section 14).
class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistProvider);
    final wishlistIds = ref.watch(wishlistIdsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist (${wishlist.length})'),
        centerTitle: false,
        actions: [
          if (wishlist.isNotEmpty)
            TextButton(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear wishlist?'),
                    content: const Text(
                      'All saved products will be removed from your wishlist.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  ref.read(wishlistProvider.notifier).clear();
                }
              },
              child: const Text('Clear all'),
            ),
        ],
      ),
      body: wishlist.isEmpty
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
                itemCount: wishlist.length,
                itemBuilder: (context, index) {
                  final product = wishlist[index];
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
                    onTap: () {
                      ref.read(recentlyViewedProvider.notifier).add(product);
                      Navigator.of(context).pushNamed(
                        AppRoutes.productDetail,
                        arguments: product.id,
                      );
                    },
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
              Icons.favorite_border,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Your wishlist is empty',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart on any product to save it here for later.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TmButton(
              text: 'Browse categories',
              variant: TmButtonVariant.primary,
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.categories),
            ),
          ],
        ),
      ),
    );
  }
}