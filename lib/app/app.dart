import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trovemart_app/core/theme/app_theme.dart';
import 'package:trovemart_app/core/routing/app_router.dart';
import 'package:trovemart_app/app/navigation_shell.dart';
import 'package:trovemart_app/features/splash/splash_screen.dart';
import 'package:trovemart_app/features/splash/splash_provider.dart';
import 'package:trovemart_app/features/onboarding/onboarding_screen.dart';
import 'package:trovemart_app/core/providers/theme_providers.dart';

/// Root widget of the Trovemart customer application.
///
/// Wraps the [MaterialApp] with theme and routing. Theme mode (light/dark/system)
/// is persisted via [themeModeProvider] and applied here.
class TrovemartApp extends ConsumerWidget {
  const TrovemartApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final theme = ref.watch(appThemeProvider);

    return MaterialApp(
      title: 'Trovemart',
      debugShowCheckedModeBanner: false,
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      themeMode: themeMode,
      home: const AppShell(),
      onGenerateRoute: AppRouter.generateRoute,
      builder: (context, child) {
        // Ensure text scaling respects system font scaling for accessibility.
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
    );
  }
}

/// Shell that decides whether to show splash/onboarding or the main navigation.
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splashStatus = ref.watch(splashProvider);

    if (splashStatus != SplashStatus.ready) {
      return const SplashScreen();
    }

    final isOnboardingCompleted =
        ref.read(splashProvider).isOnboardingCompleted;

    if (!isOnboardingCompleted) {
      return const OnboardingScreen();
    }

    return const NavigationShell();
  }
}