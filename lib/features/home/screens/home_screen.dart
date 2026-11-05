import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trovemart_app/core/routing/app_router.dart';
import 'package:trovemart_app/features/home/providers/home_provider.dart';
import 'package:trovemart_app/features/home/widgets/home_category_section.dart';
import 'package:trovemart_app/features/home/widgets/home_product_section.dart';
import 'package:trovemart_app/features/home/widgets/home_search_bar.dart';

/// Home screen — discovery-focused (Section 7).
///
/// Uses a fixed two-column product grid. Displays 9 sections in an
/// admin-controlled arrangement (mock arrangement for now; backend-controlled
/// in production). No aggressive promotional banners. Empty sections are
/// handled gracefully — never filled with fabricated products.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trovemart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            tooltip: 'Wishlist',
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.wishlist),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: sectionArrangement.map((section) {
            switch (section) {
              case HomeSection.searchBar:
                return HomeSearchBar(
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.search),
                );
              case HomeSection.categories:
                return const HomeCategorySection();
              case HomeSection.popularProducts:
                return HomeProductSection(
                  title: 'Popular products',
                  products: homeState.popularProducts,
                  routeName: AppRoutes.home,
                );
              case HomeSection.newArrivals:
                return HomeProductSection(
                  title: 'New arrivals',
                  products: homeState.newArrivals,
                  routeName: AppRoutes.home,
                );
              case HomeSection.recommendedProducts:
                return HomeProductSection(
                  title: 'Recommended products',
                  products: homeState.recommendedProducts,
                  routeName: AppRoutes.home,
                );
              case HomeSection.bestsellers:
                return HomeProductSection(
                  title: 'Bestsellers',
                  products: homeState.bestsellers,
                  routeName: AppRoutes.home,
                );
              case HomeSection.trendingProducts:
                return HomeProductSection(
                  title: 'Trending products',
                  products: homeState.trendingProducts,
                  routeName: AppRoutes.home,
                );
              case HomeSection.recentlyViewed:
                return HomeRecentlyViewedSection(
                  products: homeState.recentlyViewed,
                );
              case HomeSection.featuredCollections:
                return HomeProductSection(
                  title: 'Featured collections',
                  products: homeState.featuredCollections,
                  routeName: AppRoutes.home,
                );
            }
          }).toList(),
        ),
      ),
    );
  }
}