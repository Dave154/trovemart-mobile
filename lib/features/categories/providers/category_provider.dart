import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trovemart_app/core/mock/mock_data.dart';
import 'package:trovemart_app/features/categories/models/category.dart';
import 'package:trovemart_app/features/products/models/product.dart';

/// Category state notifier.
///
/// Manages category list and products within a selected category.
class CategoryNotifier extends StateNotifier<CategoryState> {
  CategoryNotifier() : super(const CategoryState()) {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    state = state.copyWith(isLoading: true);
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    state = state.copyWith(
      isLoading: false,
      categories: MockData.categories,
    );
  }

  /// Load products for a specific category.
  Future<void> loadCategoryProducts(String categoryId) async {
    state = state.copyWith(
      selectedCategoryId: categoryId,
      isLoadingProducts: true,
      categoryProducts: const [],
    );

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Filter mock products by category (in production, this comes from backend)
    final allProducts = MockData.products;
    final categoryProducts = allProducts
        .where((p) => p.categoryId == categoryId)
        .toList();

    state = state.copyWith(
      isLoadingProducts: false,
      categoryProducts: categoryProducts,
    );
  }

  /// Clear selected category and its products.
  void clearSelection() {
    state = state.copyWith(
      selectedCategoryId: null,
      categoryProducts: const [],
    );
  }
}

/// Category feature state.
class CategoryState {
  final List<Category> categories;
  final bool isLoading;
  final String? selectedCategoryId;
  final List<Product> categoryProducts;
  final bool isLoadingProducts;

  const CategoryState({
    this.categories = const [],
    this.isLoading = false,
    this.selectedCategoryId,
    this.categoryProducts = const [],
    this.isLoadingProducts = false,
  });

  CategoryState copyWith({
    List<Category>? categories,
    bool? isLoading,
    String? selectedCategoryId,
    List<Product>? categoryProducts,
    bool? isLoadingProducts,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      categoryProducts: categoryProducts ?? this.categoryProducts,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
    );
  }
}

/// Provider for category state.
final categoryProvider =
    StateNotifierProvider<CategoryNotifier, CategoryState>((ref) {
  return CategoryNotifier();
});

/// Provider for all categories (derived).
final categoriesProvider = Provider<List<Category>>((ref) {
  return ref.watch(categoryProvider).categories;
});

/// Provider for selected category products (derived).
final categoryProductsProvider = Provider<List<Product>>((ref) {
  return ref.watch(categoryProvider).categoryProducts;
});

/// Provider for selected category ID (derived).
final selectedCategoryIdProvider = Provider<String?>((ref) {
  return ref.watch(categoryProvider).selectedCategoryId;
});

/// Provider for category loading state (derived).
final categoryLoadingProvider = Provider<bool>((ref) {
  return ref.watch(categoryProvider).isLoading;
});

/// Provider for category products loading state (derived).
final categoryProductsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(categoryProvider).isLoadingProducts;
});