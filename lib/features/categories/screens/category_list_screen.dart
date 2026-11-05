import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trovemart_app/core/shared_widgets/tm_category_card.dart';
import 'package:trovemart_app/core/shared_widgets/tm_error_state.dart';
import 'package:trovemart_app/core/shared_widgets/tm_loading.dart';
import 'package:trovemart_app/features/categories/providers/category_provider.dart';

/// Screen displaying all product categories in a grid.
class CategoryListScreen extends ConsumerWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final isLoading = ref.watch(categoryLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: false,
      ),
      body: _buildBody(context, ref, categories, isLoading),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    List<dynamic> categories,
    bool isLoading,
  ) {
    if (isLoading) {
      return const TmLoadingPage(message: 'Loading categories...');
    }

    if (categories.isEmpty) {
      return TmErrorState(
        message: 'No categories available',
        details: 'Check back later for new categories.',
        onRetry: () => ref.read(categoryProvider.notifier)._loadCategories(),
      );
    }

    return RefreshIndicator(
      onRefresh: () async =>
          ref.read(categoryProvider.notifier)._loadCategories(),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index] as Category;
          return TmCategoryCard(
            category: category,
            onTap: () => _navigateToCategoryProducts(context, ref, category),
          );
        },
      ),
    );
  }

  void _navigateToCategoryProducts(
    BuildContext context,
    WidgetRef ref,
    Category category,
  ) {
    ref.read(categoryProvider.notifier).loadCategoryProducts(category.id);
    Navigator.of(context).pushNamed(
      '/category-products',
      arguments: category,
    );
  }
}