import 'package:flutter/material.dart';
import 'package:trovemart_app/app/navigation_shell.dart';
import 'package:trovemart_app/features/authentication/screens/email_verification_screen.dart';
import 'package:trovemart_app/features/authentication/screens/forgot_password_screen.dart';
import 'package:trovemart_app/features/authentication/screens/login_screen.dart';
import 'package:trovemart_app/features/authentication/screens/register_screen.dart';
import 'package:trovemart_app/features/categories/screens/category_list_screen.dart';
import 'package:trovemart_app/features/categories/screens/category_products_screen.dart';
import 'package:trovemart_app/features/home/screens/home_screen.dart';
import 'package:trovemart_app/features/onboarding/onboarding_screen.dart';
import 'package:trovemart_app/features/products/screens/product_detail_screen.dart';
import 'package:trovemart_app/features/recently_viewed/screens/recently_viewed_screen.dart';
import 'package:trovemart_app/features/search/screens/search_screen.dart';
import 'package:trovemart_app/features/splash/splash_screen.dart';
import 'package:trovemart_app/features/wishlist/screens/wishlist_screen.dart';

/// Named routes used by the Trovemart application.
///
/// Navigation uses Flutter's standard Navigator (Section 6). No external
/// routing dependencies are added.
abstract class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String cart = '/cart';
  static const String account = '/account';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String emailVerification = '/email-verification';
  static const String productDetail = '/product-detail';
  static const String search = '/search';
  static const String wishlist = '/wishlist';
  static const String orders = '/orders';
  static const String orderTracking = '/order-tracking';
  static const String checkout = '/checkout';
  static const String addresses = '/addresses';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String support = '/support';
}

/// Generates routes for named navigation.
///
/// Returns real screens for implemented features; placeholder stubs for
/// features to be built in subsequent phases (Section 37).
class AppRouter {
  AppRouter._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final routeName = settings.name ?? '/';

    switch (routeName) {
      case AppRoutes.splash:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );
      case AppRoutes.onboarding:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const OnboardingScreen(),
        );
      case AppRoutes.home:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );
      case AppRoutes.categories:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const CategoryListScreen(),
        );
      case '/category-products':
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const CategoryProductsScreen(),
        );
      case AppRoutes.productDetail:
        final productId = settings.arguments as String?;
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => ProductDetailScreen(productId: productId ?? ''),
        );
      case AppRoutes.search:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SearchScreen(),
        );
      case AppRoutes.wishlist:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const WishlistScreen(),
        );
      case '/recently-viewed':
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const RecentlyViewedScreen(),
        );
      case AppRoutes.login:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );
      case AppRoutes.register:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const RegisterScreen(),
        );
      case AppRoutes.forgotPassword:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const ForgotPasswordScreen(),
        );
      case AppRoutes.emailVerification:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const EmailVerificationScreen(),
        );
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => _PlaceholderScreen(routeName: routeName),
        );
    }
  }
}

/// Placeholder screen used until real feature screens are built.
class _PlaceholderScreen extends StatelessWidget {
  final String routeName;
  const _PlaceholderScreen({required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(routeName)),
      body: Center(
        child: Text('Screen: $routeName\n(Placeholder — Phase 4+)'),
      ),
    );
  }
}