/// Cart item model — mock data placeholder.
class CartItem {
  final String productId;
  final String productName;
  final String productImageUrl;
  final double currentPrice;
  final double? previousPrice;
  final int quantity;
  final ProductVariant? selectedVariant;
  final bool inStock;
  final String stockStatus;

  const CartItem({
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    required this.currentPrice,
    this.previousPrice,
    required this.quantity,
    this.selectedVariant,
    required this.inStock,
    required this.stockStatus,
  });

  /// Line subtotal for this cart item (current price × quantity).
  double get subtotal => currentPrice * quantity;

  /// Whether this item can be selected for checkout.
  bool get isSelectable => inStock && stockStatus != 'out_of_stock';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem && productId == other.productId;

  @override
  int get hashCode => productId.hashCode;
}

/// Mock cart item factory.
extension CartItemMock on CartItem {
  factory CartItem.mock({
    required String productId,
    required String productName,
    required double currentPrice,
  }) {
    return CartItem(
      productId: productId,
      productName: productName,
      productImageUrl: 'https://via.placeholder.com/100x100.png?text=$productName',
      currentPrice: currentPrice,
      quantity: 1,
      inStock: true,
      stockStatus: 'in_stock',
    );
  }
}