import 'package:flutter/material.dart';
import 'package:trovemart_app/core/mock/mock_data.dart';
import 'package:trovemart_app/core/shared_widgets/tm_button.dart';
import 'package:trovemart_app/core/shared_widgets/tm_product_card.dart';
import 'package:trovemart_app/core/theme/app_theme.dart';
import 'package:trovemart_app/features/products/models/product.dart';

/// Product details screen (Section 9).
///
/// Swipeable product-image gallery with image counter, product name, pricing,
/// discount information, ratings, reviews, variants, stock availability,
/// delivery information, expandable description, specifications, related
/// products, sticky Add to Cart and Buy Now buttons, and share button.
class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;
  ProductVariant? _selectedVariant;
  bool _isExpanded = false;
  int _quantity = 1;

  Product get _product {
    return MockData.products.firstWhere(
      (p) => p.id == widget.productId,
      orElse: () => Product.mock(id: widget.productId, name: 'Product', currentPrice: 0),
    );
  }

  double get _effectivePrice {
    if (_selectedVariant != null && _selectedVariant!.priceAdjustment != 0) {
      return _product.currentPrice + _selectedVariant!.priceAdjustment;
    }
    return _product.currentPrice;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageGallery(context),
                  _buildProductInfo(context),
                  _buildVariantsSection(context),
                  _buildStockAndDelivery(context),
                  _buildDescriptionSection(context),
                  _buildSpecificationsSection(context),
                  _buildReviewsSection(context),
                  _buildRelatedProducts(context),
                ],
              ),
            ),
          ),
          _buildStickyCheckoutBar(context),
        ],
      ),
    );
  }

  Widget _buildImageGallery(BuildContext context) {
    final images = _product.imageUrls.isNotEmpty
        ? _product.imageUrls
        : [_product.imageUrl];

    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              height: 320,
              width: double.infinity,
              child: PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                onPageChanged: (index) =>
                    setState(() => _currentImageIndex = index),
                itemBuilder: (context, index) {
                  return Image.network(
                    images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: const Icon(Icons.broken_image, size: 40),
                    ),
                  );
                },
              ),
            ),
            // Image counter
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${_currentImageIndex + 1} / ${images.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // Share button
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.share, size: 20),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ),
          ],
        ),
        if (images.length > 1)
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                final isSelected = index == _currentImageIndex;
                return GestureDetector(
                  onTap: () =>
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outlineVariant,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _product.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _product.brand,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.favorite_outline),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '₦${_effectivePrice.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (_product.isDiscounted) ...[
                const SizedBox(width: 8),
                Text(
                  '₦${_product.previousPrice!.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Save ${_product.discountPercentage!.round()}%',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, size: 18, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                '${_product.rating.toStringAsFixed(1)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: 4),
              Text(
                '(${_product.reviewCount} reviews)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVariantsSection(BuildContext context) {
    if (_product.variants.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose options',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ..._product.variants.map((variantGroup) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    variantGroup.name,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 1,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(variantGroup.value),
                        selected: _selectedVariant?.id == variantGroup.id,
                        onSelected: (selected) => setState(() =>
                            _selectedVariant = selected ? variantGroup : null),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildStockAndDelivery(BuildContext context) {
    final inStock = _product.inStock;
    final stockStatus = _product.stockStatus;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                inStock ? Icons.check_circle : Icons.error_outline,
                color: inStock
                    ? AppColors.success
                    : Theme.of(context).colorScheme.error,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                stockStatus == 'in_stock'
                    ? 'In Stock'
                    : stockStatus == 'low_stock'
                        ? 'Low stock — order soon'
                        : 'Out of Stock',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: inStock
                    ? AppColors.success
                    : stockStatus == 'low_stock'
                        ? AppColors.warning
                        : Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.local_shipping, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Nationwide delivery across Nigeria\nEstimated delivery: 3-5 business days',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Product Description',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              TextButton(
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
                child: Text(_isExpanded ? 'Show less' : 'Read more'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _isExpanded
                ? _product.description
                : _product.description.length > 180
                    ? '${_product.description.substring(0, 180)}...'
                    : _product.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificationsSection(BuildContext context) {
    if (_product.variants.isEmpty && !_product.isFeatured) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Specifications',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          if (_product.variants.isNotEmpty)
            ..._product.variants.map((variant) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        variant.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        variant.value,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Customer Reviews',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                '${_product.reviewCount} reviews',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star, size: 20, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                '${_product.rating.toStringAsFixed(1)} / 5',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedProducts(BuildContext context) {
    final related = MockData.products.where(
      (p) => p.id != _product.id && p.categoryId == _product.categoryId,
    ).take(4).toList();

    if (related.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Related Products',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: related.length,
              itemBuilder: (context, index) {
                final product = related[index];
                return SizedBox(
                  width: 150,
                  child: TmProductCard(
                    product: product,
                    isInWishlist: false,
                    onWishlistToggle: () {},
                    onAddToCart: () {},
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyCheckoutBar(BuildContext context) {
    if (!_product.inStock) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₦${_effectivePrice.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    _stockStatus,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _stockColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 100,
                  child: DropdownButtonFormField<int>(
                    value: _quantity,
                    items: List.generate(10, (i) => i + 1)
                        .map((q) => DropdownMenuItem<int>(
                      value: q,
                      child: Text('$q'),
                    ))
                        .toList(),
                    onChanged: (val) => setState(() => _quantity = val ?? 1),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 52,
                child: TmButton(
                  text: 'Add to Cart',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${_product.name} added to cart')),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _stockStatus {
    if (!_product.inStock) return 'Out of Stock';
    if (_product.stockStatus == 'low_stock') return 'Low stock — order soon';
    return 'In Stock';
  }

  Color get _stockColor {
    if (!_product.inStock) return AppColors.warning;
    if (_product.stockStatus == 'low_stock') return AppColors.warning;
    return AppColors.success;
  }
}
