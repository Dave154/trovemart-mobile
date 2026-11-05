import 'package:flutter/material.dart';
import 'package:trovemart_app/core/shared_widgets/tm_category_card.dart';
import 'package:trovemart_app/features/categories/models/category.dart';
import 'package:trovemart_app/core/mock/mock_data.dart';

/// Product categories section for the home screen (Section 7).
class HomeCategorySection extends StatelessWidget {
  const HomeCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = MockData.categories;

    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/categories'),
                child: const Text('View all'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: 140,
                  child: TmCategoryCard(
                    category: category,
                    onTap: () =>
                        Navigator.of(context).pushNamed(
                          '/category-products',
                          arguments: category,
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
}