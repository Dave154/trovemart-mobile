import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trovemart_app/core/constants/app_constants.dart';
import 'package:trovemart_app/core/storage/local_storage.dart';
import 'package:trovemart_app/core/theme/app_theme.dart';

/// Persisted theme mode preference. Defaults to [ThemeMode.system].
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

/// Provides the [AppTheme] instance (read-only theme data).
final appThemeProvider = Provider<AppTheme>((ref) {
  return const AppTheme();
});

/// Manages theme mode state with persistence to local storage.
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(AppConstants.defaultThemeMode) {
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    final saved = LocalStorage.getThemeMode();
    if (saved != null) {
      state = ThemeMode.values.firstWhere(
        (e) => e.index == saved,
        orElse: () => AppConstants.defaultThemeMode,
      );
    }
  }

  /// Sets the theme mode and persists it.
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await LocalStorage.setThemeMode(mode.index);
  }
}