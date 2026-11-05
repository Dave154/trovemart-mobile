import 'package:flutter/material.dart';

/// Search bar for the home screen (Section 7).
class HomeSearchBar extends StatelessWidget {
  final String? hint;
  final VoidCallback? onTap;

  const HomeSearchBar({super.key, this.hint, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: ListTile(
        leading: Icon(
          Icons.search,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        title: Text(
          hint ?? 'Search products, brands, and more',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
        trailing: Icon(
          Icons.filter_list_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        onTap: onTap,
      ),
    );
  }
}