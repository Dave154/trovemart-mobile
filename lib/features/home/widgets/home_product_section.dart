import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trovemart_app/core/shared_widgets/tm_product_card.dart';
import 'package:trovemart_app/features/products/models/product.dart';
import 'package:trovemart_app/features/recently_viewed/providers/recently_viewed_provider.dart';
import 'package:trovemart_app/features/wishlist/providers/wishlist_provider.dart';

/// Generic product grid section for home screen (Section 7).
///
/// Displays products in a fixed two-column grid. Handles empty sections
/// gracefully — never fills with fabricated products.
class HomeProductSection extends ConsumerWidget {
  final String title;
  final List<Product> products;
  final String routeName;
  final bool isRecentlyViewed;

  const HomeProductSection({
    super.key,
    required this.title,
    required this.products,
    required this.routeName,
    this.isRecentlyViewed = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed(routeName),
                child: const Text('View all'),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final wishlistIds = ref.watch(wishlistIdsProvider);
            return TmProductCard(
              product: product,
              isInWishlist: wishlistIds.contains(product.id),
              onWishlistToggle: () =>
                  ref.read(wishlistProvider.notifier).toggle(product),
              onAddToCart: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} added to cart')),
                );
              },
              onTap: () {
                ref.read(recentlyViewedProvider.notifier).add(product);
                Navigator.of(context).pushNamed(
                  '/product-detail',
                  arguments: product.id,
                );
              },
            );
          },
        ),
      ],
    );
  }
}

/// Recently viewed products section for the home screen (Section 16).
class HomeRecentlyViewedSection extends ConsumerWidget {
  final List<Product> products;

  const HomeRecentlyViewedSection({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyViewed = products;

    if (recentlyViewed.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recently viewed',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed('/recently-viewed'),
                child: const Text('View all'),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: recentlyViewed.length,
          itemBuilder: (context, index) {
            final product = recentlyViewed[index];
            final wishlistIds = ref.watch(wishlistIdsProvider);
            return TmProductCard(
              product: product,
              isInWishlist: wishlistIds.contains(product.id),
              onWishlistToggle: () =>
                  ref.read(wishlistProvider.notifier).toggle(product),
              onAddToCart: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} added to cart')),
                );
              },
              onTap: () {
                ref.read(recentlyViewedProvider.notifier).add(product);
                Navigator.of(context).pushNamed(
                  '/product-detail',
                  arguments: product.id,
                );
              },
            );
          },
        ),
      ],
    );
  }
}