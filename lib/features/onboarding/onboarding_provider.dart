import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trovemart_app/core/storage/local_storage.dart';

/// Onboarding state provider.
final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier();
});

/// Manages onboarding completion state.
class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(LocalStorage.getOnboardingCompleted());

  /// Marks onboarding as completed and persists it.
  Future<void> completeOnboarding() async {
    state = true;
    await LocalStorage.setOnboardingCompleted(true);
  }
}