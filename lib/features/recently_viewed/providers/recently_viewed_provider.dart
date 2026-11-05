import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trovemart_app/core/constants/app_constants.dart';
import 'package:trovemart_app/core/mock/mock_data.dart';
import 'package:trovemart_app/core/storage/local_storage.dart';
import 'package:trovemart_app/features/products/models/product.dart';

/// Recently viewed products notifier.
///
/// Maintains a maximum of 10 products, newest first, with no duplicates
/// (Section 16). Persisted to local storage.
class RecentlyViewedNotifier extends StateNotifier<List<Product>> {
  RecentlyViewedNotifier() : super(const []) {
    _loadRecentlyViewed();
  }

  Future<void> _loadRecentlyViewed() async {
    final ids = LocalStorage.getRecentlyViewed();
    // Resolve stored IDs against the available catalog. In production this
    // fetches product details by IDs from the backend (Section 16).
    final loaded = <Product>[];
    for (final id in ids) {
      for (final product in MockData.products) {
        if (product.id == id) {
          loaded.add(product);
          break;
        }
      }
    }
    state = loaded;
  }

  /// Adds a product to recently viewed history.
  Future<void> add(Product product) async {
    // Avoid duplicates
    if (state.any((p) => p.id == product.id)) {
      state = [
        product,
        ...state.where((p) => p.id != product.id),
      ];
    } else {
      state = [product, ...state];
    }

    // Enforce max of 10
    if (state.length > AppConstants.maxRecentlyViewed) {
      state = state.take(AppConstants.maxRecentlyViewed).toList();
    }

    await _persist();
  }

  Future<void> _persist() async {
    final ids = state.map((p) => p.id).toList();
    await LocalStorage.setRecentlyViewed(ids);
  }

  /// Clears all recently viewed products.
  Future<void> clear() async {
    state = const [];
    await LocalStorage.setRecentlyViewed(<String>[]);
  }
}

/// Provider for recently viewed products.
final recentlyViewedProvider =
    StateNotifierProvider<RecentlyViewedNotifier, List<Product>>((ref) {
  return RecentlyViewedNotifier();
});