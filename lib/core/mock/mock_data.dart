/// Mock data for development and testing (Section 32).
///
/// ⚠️  MOCK DATA ONLY — Never mistake this for production data.
/// Backend API contracts will replace this data once delivered.
import 'package:trovemart_app/features/products/models/product.dart';
import 'package:trovemart_app/features/categories/models/category.dart';
import 'package:trovemart_app/features/cart/models/cart_item.dart';

class MockData {
  MockData._();

  /// Mock products for development.
  static List<Product> get products => [
    // Fashion (cat_1)
    Product.mock(id: 'p1', name: 'Lagos Leather Sandals', currentPrice: 12500.0)
        .copyWith(categoryId: 'cat_1'),
    Product.mock(id: 'p2', name: 'Abuja Cotton Shirt', currentPrice: 8500.0)
        .copyWith(categoryId: 'cat_1'),
    Product.mock(id: 'p7', name: 'Enugu Ankara Fabric', currentPrice: 9500.0)
        .copyWith(categoryId: 'cat_1'),
    // Home & Living (cat_2)
    Product.mock(id: 'p3', name: 'Kano Ceramic Pot', currentPrice: 4200.0)
        .copyWith(categoryId: 'cat_2'),
    Product.mock(id: 'p4', name: 'Ibadan Woven Basket', currentPrice: 6800.0)
        .copyWith(categoryId: 'cat_2'),
    Product.mock(id: 'p6', name: 'Kaduna Wooden Spoon Set', currentPrice: 5500.0)
        .copyWith(categoryId: 'cat_2'),
    // Beauty & Personal Care (cat_5)
    Product.mock(id: 'p5', name: 'Port Harcourt Beaded Bracelet', currentPrice: 3200.0)
        .copyWith(categoryId: 'cat_5'),
    // Electronics (cat_3) - placeholder for future
    Product.mock(id: 'p8', name: 'Benin Bronze Sculpture', currentPrice: 25000.0)
        .copyWith(categoryId: 'cat_3'),
  ];

  /// Mock categories for development.
  static List<Category> get categories => [
    Category.mock(id: 'cat_1', name: 'Fashion'),
    Category.mock(id: 'cat_2', name: 'Home & Living'),
    Category.mock(id: 'cat_3', name: 'Electronics'),
    Category.mock(id: 'cat_4', name: 'Groceries'),
    Category.mock(id: 'cat_5', name: 'Beauty & Personal Care'),
  ];

  /// Mock cart items for development.
  static List<CartItem> get cartItems => [
    CartItem.mock(
      productId: 'p1',
      productName: 'Lagos Leather Sandals',
      currentPrice: 12500.0,
    ),
  ];
}