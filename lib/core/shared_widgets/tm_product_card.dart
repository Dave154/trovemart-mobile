import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:trovemart_app/core/shared_widgets/tm_product_card_skeleton.dart';
import 'package:trovemart_app/features/products/models/product.dart';

/// Hybrid commercial product card (Section 8).
///
/// Displays: product image, name, current price, previous price (when
/// discounted), rating, review count, discount label, wishlist icon, and
/// quick Add to Cart button.
class TmProductCard extends StatelessWidget {
  final Product product;
  final bool isLoading;
  final bool isInWishlist;
  final VoidCallback onWishlistToggle;
  final VoidCallback onAddToCart;
  final VoidCallback onTap;

  const TmProductCard({
    super.key,
    required this.product,
    this.isLoading = false,
    required this.isInWishlist,
    required this.onWishlistToggle,
    required this.onAddToCart,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const TmProductCardSkeleton();
    }

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(context),
            _buildDetailsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          child: Image.network(
            product.imageUrl,
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 160,
              width: double.infinity,
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: const Icon(Icons.broken_image, size: 40),
            ),
          ),
        ),
        if (product.isDiscounted)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '-${product.discountPercentage?.round() ?? 0}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                isInWishlist ? LucideIcons.heart : LucideIcons.heartOff,
                color: isInWishlist ? Colors.red : null,
                size: 20,
              ),
              onPressed: onWishlistToggle,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '₦${product.currentPrice.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (product.isDiscounted) ...[
                const SizedBox(width: 8),
                Text(
                  '₦${product.previousPrice!.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                '${product.rating.toStringAsFixed(1)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 6),
              Text(
                '(${product.reviewCount})',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TmButton(
                  text: 'Add',
                  variant: TmButtonVariant.outline,
                  onPressed: product.inStock ? onAddToCart : null,
                  isFullWidth: false,
                ),
              ),
              const SizedBox(width: 8),
              if (!product.inStock)
                Text(
                  'Out of Stock',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                )
              else
                const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}