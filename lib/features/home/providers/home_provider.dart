import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trovemart_app/features/products/models/product.dart';

/// Home screen section types.
enum HomeSection {
  searchBar,
  categories,
  popularProducts,
  newArrivals,
  recommendedProducts,
  bestsellers,
  trendingProducts,
  recentlyViewed,
  featuredCollections,
}

/// Mock admin-controlled section arrangement.
/// In production, this comes from the backend API (Section 7).
const List<HomeSection> sectionArrangement = [
  HomeSection.searchBar,
  HomeSection.categories,
  HomeSection.popularProducts,
  HomeSection.newArrivals,
  HomeSection.recommendedProducts,
  HomeSection.bestsellers,
  HomeSection.trendingProducts,
  HomeSection.recentlyViewed,
  HomeSection.featuredCollections,
];

/// Home screen state provider.
///
/// Manages product data for display (mock admin-controlled arrangement)
class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState()) {
    _loadMockData();
  }

  Future<void> _loadMockData() async {
    // In production, load from backend API (Section 7).
    // For development, start with empty lists.
    state = state.copyWith(
      popularProducts: const [],
      newArrivals: const [],
      recommendedProducts: const [],
      bestsellers: const [],
      trendingProducts: const [],
      featuredCollections: const [],
      recentlyViewed: const [],
    );
  }
}

/// Home screen state.
class HomeState {
  final List<Product> popularProducts;
  final List<Product> newArrivals;
  final List<Product> recommendedProducts;
  final List<Product> bestsellers;
  final List<Product> trendingProducts;
  final List<Product> featuredCollections;
  final List<Product> recentlyViewed;

  const HomeState({
    this.popularProducts = const [],
    this.newArrivals = const [],
    this.recommendedProducts = const [],
    this.bestsellers = const [],
    this.trendingProducts = const [],
    this.featuredCollections = const [],
    this.recentlyViewed = const [],
  });

  HomeState copyWith({
    List<Product>? popularProducts,
    List<Product>? newArrivals,
    List<Product>? recommendedProducts,
    List<Product>? bestsellers,
    List<Product>? trendingProducts,
    List<Product>? featuredCollections,
    List<Product>? recentlyViewed,
  }) {
    return HomeState(
      popularProducts: popularProducts ?? this.popularProducts,
      newArrivals: newArrivals ?? this.newArrivals,
      recommendedProducts: recommendedProducts ?? this.recommendedProducts,
      bestsellers: bestsellers ?? this.bestsellers,
      trendingProducts: trendingProducts ?? this.trendingProducts,
      featuredCollections: featuredCollections ?? this.featuredCollections,
      recentlyViewed: recentlyViewed ?? this.recentlyViewed,
    );
  }
}

/// Provider for home screen state.
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});