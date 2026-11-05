import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trovemart_app/core/mock/mock_data.dart';
import 'package:trovemart_app/core/storage/local_storage.dart';
import 'package:trovemart_app/features/products/models/product.dart';

/// Wishlist notifier.
///
/// Maintains saved products (max unrestricted, newest first), persisted as
/// product IDs to local storage. Products are resolved from the mock catalog
/// until backend contracts are delivered (Section 32).
class WishlistNotifier extends StateNotifier<List<Product>> {
  WishlistNotifier() : super(const []) {
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final ids = LocalStorage.getWishlist();
    final saved = <Product>[];
    for (final id in ids) {
      for (final product in MockData.products) {
        if (product.id == id) {
          saved.add(product);
          break;
        }
      }
    }
    state = saved;
  }

  /// Toggles a product's wishlist membership. Returns true if now saved.
  Future<bool> toggle(Product product) async {
    final exists = state.any((p) => p.id == product.id);
    if (exists) {
      state = state.where((p) => p.id != product.id).toList();
    } else {
      state = [product, ...state];
    }
    await _persist();
    return !exists;
  }

  /// Removes a product from the wishlist.
  Future<void> remove(String productId) async {
    state = state.where((p) => p.id != productId).toList();
    await _persist();
  }

  /// Clears all wishlist items.
  Future<void> clear() async {
    state = const [];
    await LocalStorage.setWishlist(<String>[]);
  }

  Future<void> _persist() async {
    await LocalStorage.setWishlist(state.map((p) => p.id).toList());
  }
}

/// Provider for wishlist products.
final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, List<Product>>((ref) {
  return WishlistNotifier();
});

/// Provider for the set of wishlisted product IDs (fast contains checks).
final wishlistIdsProvider = Provider<Set<String>>((ref) {
  return ref.watch(wishlistProvider).map((p) => p.id).toSet();
});