import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trovemart_app/core/shared_widgets/tm_logo.dart';
import 'package:trovemart_app/core/theme/app_theme.dart';
import 'package:trovemart_app/core/routing/app_router.dart';
import 'package:trovemart_app/features/splash/splash_provider.dart';
import 'package:trovemart_app/features/onboarding/onboarding_screen.dart';

/// Branded splash screen (Section 5).
///
/// Displays the Trovemart logo, brand name, and a lightweight animation.
/// Appearance adapts to the active theme. After the splash duration, navigates
/// to onboarding (first launch) or home (returning users).
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splashStatus = ref.watch(splashProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Trovemart brand logo (asset with programmatic fallback).
            TmLogo(size: 120),
            const SizedBox(height: 24),
            Text(
              'Trovemart',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Quality products delivered to your door',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            // Lightweight pulse animation.
            if (splashStatus == SplashStatus.initializing ||
                splashStatus == SplashStatus.checkingOnboarding)
              const SizedBox(
                height: 36,
                width: 36,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
          ],
        ),
      ),
    );
  }
}

/// Routes from splash to the appropriate next screen.
class SplashRouter extends ConsumerWidget {
  const SplashRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splashStatus = ref.watch(splashProvider);

    if (splashStatus != SplashStatus.ready) {
      return const SplashScreen();
    }

    final isOnboardingCompleted = ref.read(splashProvider.notifier).isOnboardingCompleted;

    if (!isOnboardingCompleted) {
      return const OnboardingScreen();
    }

    // Navigate to home after splash.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    });

    return const SplashScreen();
  }
}