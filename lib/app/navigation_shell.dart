import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trovemart_app/core/theme/app_theme.dart';
import 'package:trovemart_app/core/routing/app_router.dart';
import 'package:trovemart_app/features/onboarding/onboarding_provider.dart';

/// Bottom tab items for the main navigation shell.
class _TabItem {
  const _TabItem({
    required this.route,
    required this.icon,
    required this.label,
  });

  final String route;
  final IconData icon;
  final String label;
}

/// Navigation shell with 4 persistent bottom tabs.
///
/// Tab state is preserved using an IndexedStack — each tab maintains its own
/// Navigator so that switching tabs does not discard navigation state
/// (Section 6).
class NavigationShell extends ConsumerStatefulWidget {
  const NavigationShell({super.key});

  @override
  ConsumerState<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends ConsumerState<NavigationShell> {
  static const List<_TabItem> _tabs = [
    _TabItem(
      route: AppRoutes.home,
      icon: Icons.home_outlined,
      label: 'Home',
    ),
    _TabItem(
      route: AppRoutes.categories,
      icon: Icons.grid_view_outlined,
      label: 'Categories',
    ),
    _TabItem(
      route: AppRoutes.cart,
      icon: Icons.shopping_cart_outlined,
      label: 'Cart',
    ),
    _TabItem(
      route: AppRoutes.account,
      icon: Icons.person_outlined,
      label: 'Account',
    ),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: List.generate(_tabs.length, (index) {
            return _TabNavigator(
              tabItem: _tabs[index],
              isSelected: index == _selectedIndex,
            );
          }),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurface
                : AppColors.lightSurface,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerTheme.color!,
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Row(
              children: List.generate(_tabs.length, (index) {
                final tab = _tabs[index];
                final isSelected = _selectedIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedIndex = index);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          tab.icon,
                          size: 24,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tab.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

/// Individual tab navigator with its own navigation stack.
class _TabNavigator extends StatelessWidget {
  final _TabItem tabItem;
  final bool isSelected;

  const _TabNavigator({
    super.key,
    required this.tabItem,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: GlobalKey(),
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => _TabContent(tabItem: tabItem, isSelected: isSelected),
        );
      },
    );
  }
}

/// Content for each tab — currently placeholder until feature screens are built.
class _TabContent extends StatelessWidget {
  final _TabItem tabItem;
  final bool isSelected;

  const _TabContent({
    required this.tabItem,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tabItem.label),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(tabItem.icon, size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              '${tabItem.label} Screen',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Placeholder — Feature screen in Phase 4+',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}