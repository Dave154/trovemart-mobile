import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trovemart_app/core/storage/local_storage.dart';
import 'package:trovemart_app/core/constants/app_constants.dart';

/// Splash screen state.
enum SplashStatus { initializing, checkingOnboarding, ready }

/// Manages splash screen logic: checks onboarding completion status.
class SplashNotifier extends StateNotifier<SplashStatus> {
  SplashNotifier() : super(SplashStatus.initializing) {
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    state = SplashStatus.checkingOnboarding;
    // Simulate a lightweight splash animation duration.
    await Future.delayed(const Duration(seconds: 2));
    final completed = LocalStorage.getOnboardingCompleted();
    state = SplashStatus.ready;
    if (!completed) {
      // Signal that onboarding is required.
    }
  }

  /// Whether onboarding has been completed.
  bool get isOnboardingCompleted => LocalStorage.getOnboardingCompleted();
}

/// Provider for splash screen state.
final splashProvider = StateNotifierProvider<SplashNotifier, SplashStatus>((ref) {
  return SplashNotifier();
});