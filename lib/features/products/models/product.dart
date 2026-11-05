/// Product model — mock data placeholder (Section 32: mock data must never
/// be mistaken for production data).
///
/// This model matches the expected backend contract shape. Actual fields
/// will be confirmed once backend API contracts are delivered.
class Product {
  final String id;
  final String name;
  final String description;
  final String brand;
  final String imageUrl;
  final List<String> imageUrls;
  final double currentPrice;
  final double? previousPrice;
  final double? discountPercentage;
  final double rating;
  final int reviewCount;
  final bool inStock;
  final String stockStatus; // 'in_stock', 'low_stock', 'out_of_stock'
  final List<ProductVariant> variants;
  final String categoryId;
  final bool isFeatured;
  final bool isBestseller;
  final bool isNewArrival;
  final bool isTrending;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.brand,
    required this.imageUrl,
    this.imageUrls = const [],
    required this.currentPrice,
    this.previousPrice,
    this.discountPercentage,
    required this.rating,
    required this.reviewCount,
    required this.inStock,
    required this.stockStatus,
    this.variants = const [],
    required this.categoryId,
    this.isFeatured = false,
    this.isBestseller = false,
    this.isNewArrival = false,
    this.isTrending = false,
  });

  /// Whether the product is genuinely discounted.
  bool get isDiscounted => previousPrice != null && previousPrice! > currentPrice;

  /// Creates a Product from mock data (for development only).
  factory Product.mock({
    required String id,
    required String name,
    required double currentPrice,
  }) {
    return Product(
      id: id,
      name: name,
      description: 'Mock product description for $name.',
      brand: 'Trovemart',
      imageUrl: 'https://via.placeholder.com/300x300.png?text=$name',
      currentPrice: currentPrice,
      previousPrice: currentPrice * 1.2,
      rating: 4.5,
      reviewCount: 128,
      inStock: true,
      stockStatus: 'in_stock',
      categoryId: 'cat_1',
    );
  }

  @override
  String toString() => 'Product(id: $id, name: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Product && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? brand,
    String? imageUrl,
    List<String>? imageUrls,
    double? currentPrice,
    double? previousPrice,
    double? discountPercentage,
    double? rating,
    int? reviewCount,
    bool? inStock,
    String? stockStatus,
    List<ProductVariant>? variants,
    String? categoryId,
    bool? isFeatured,
    bool? isBestseller,
    bool? isNewArrival,
    bool? isTrending,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      brand: brand ?? this.brand,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      currentPrice: currentPrice ?? this.currentPrice,
      previousPrice: previousPrice ?? this.previousPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      inStock: inStock ?? this.inStock,
      stockStatus: stockStatus ?? this.stockStatus,
      variants: variants ?? this.variants,
      categoryId: categoryId ?? this.categoryId,
      isFeatured: isFeatured ?? this.isFeatured,
      isBestseller: isBestseller ?? this.isBestseller,
      isNewArrival: isNewArrival ?? this.isNewArrival,
      isTrending: isTrending ?? this.isTrending,
    );
  }
}

/// Product variant (size, colour, model, storage, package size).
class ProductVariant {
  final String id;
  final String name;
  final String value;
  final double priceAdjustment;
  final int stockQuantity;

  const ProductVariant({
    required this.id,
    required this.name,
    required this.value,
    this.priceAdjustment = 0.0,
    required this.stockQuantity,
  });

  factory ProductVariant.mock() => const ProductVariant(
        id: 'var_1',
        name: 'Size',
        value: 'Medium',
        priceAdjustment: 0.0,
        stockQuantity: 50,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ProductVariant && id == other.id;

  @override
  int get hashCode => id.hashCode;
}