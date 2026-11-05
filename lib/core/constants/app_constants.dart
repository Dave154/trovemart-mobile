/// Central application constants for Trovemart.
///
/// These values are configuration, not secrets. Secrets (API keys, tokens) must
/// never be hardcoded here — they belong in environment variables / .env.
class AppConstants {
  AppConstants._();

  /// Application name displayed to users.
  static const String appName = 'Trovemart';

  /// Current application version (semantic versioning).
  static const String appVersion = '1.0.0';

  /// Default page size for paginated API requests.
  static const int defaultPageSize = 20;

  /// Maximum number of recently viewed products to retain.
  static const int maxRecentlyViewed = 10;

  /// Default theme mode (system) index matching [ThemeMode] values.
  static const ThemeMode defaultThemeMode = ThemeMode.system;

  /// Animation duration for standard page transitions (milliseconds).
  static const int pageTransitionDurationMs = 300;

  /// Animation duration for interactive controls (milliseconds).
  static const int interactiveAnimationDurationMs = 200;

  /// Cache TTL in seconds for product listings (5 minutes).
  static const int productListingCacheTtlSeconds = 300;

  /// Cache TTL in seconds for product details (10 minutes).
  static const int productDetailCacheTtlSeconds = 600;

  // ---------------------------------------------------------------------------
  // API configuration keys (values loaded from .env at runtime)
  // ---------------------------------------------------------------------------
  static const String envBaseUrl = 'API_BASE_URL';
  static const String envEnvironment = 'APP_ENVIRONMENT';

  // ---------------------------------------------------------------------------
  // Local storage keys
  // ---------------------------------------------------------------------------
  static const String storageKeyThemeMode = 'theme_mode';
  static const String storageKeyAuthToken = 'auth_token';
  static const String storageKeyUserId = 'user_id';
  static const String storageKeyRecentlyViewed = 'recently_viewed';
  static const String storageKeyOnboardingCompleted = 'onboarding_completed';
  static const String storageKeyWishlist = 'wishlist_ids';
}