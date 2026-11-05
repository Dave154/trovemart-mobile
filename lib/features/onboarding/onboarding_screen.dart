import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trovemart_app/core/shared_widgets/tm_logo.dart';
import 'package:trovemart_app/core/theme/app_theme.dart';
import 'package:trovemart_app/core/shared_widgets/tm_button.dart';
import 'package:trovemart_app/features/onboarding/onboarding_provider.dart';
import 'package:trovemart_app/core/routing/app_router.dart';

/// Minimal first-launch onboarding experience (Section 5).
///
/// Shows the logo, short introduction, and a Continue button.
/// Shown only once — after completion it is never shown again.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            TmLogo(size: 100),
            const SizedBox(height: 32),
            Text(
              'Welcome to Trovemart',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'Discover quality products delivered nationwide across Nigeria.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            TmButton(
              text: 'Continue',
              variant: TmButtonVariant.primary,
              isFullWidth: false,
              onPressed: () async {
                await ref.read(onboardingProvider.notifier).completeOnboarding();
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}