import 'package:shared_preferences/shared_preferences.dart';
import 'package:trovemart_app/core/constants/app_constants.dart';

/// Thin wrapper over SharedPreferences for persisting customer preferences
/// and cached data (Section 31: local storage is for caching and preferences,
/// never for overriding backend business rules).
class LocalStorage {
  LocalStorage._();

  static SharedPreferences? _prefs;

  /// Initialises storage. Must be called before any read/write.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _instance {
    if (_prefs == null) {
      throw StateError('LocalStorage not initialized. Call LocalStorage.init() first.');
    }
    return _prefs!;
  }

  // ---------------------------------------------------------------------------
  // Theme mode
  // ---------------------------------------------------------------------------
  static Future<void> setThemeMode(int value) async {
    await _instance.setInt(AppConstants.storageKeyThemeMode, value);
  }

  static int? getThemeMode() => _instance.getInt(AppConstants.storageKeyThemeMode);

  // ---------------------------------------------------------------------------
  // Auth token
  // ---------------------------------------------------------------------------
  static Future<void> setAuthToken(String token) async {
    await _instance.setString(AppConstants.storageKeyAuthToken, token);
  }

  static String? getAuthToken() => _instance.getString(AppConstants.storageKeyAuthToken);

  static Future<void> clearAuthToken() async {
    await _instance.remove(AppConstants.storageKeyAuthToken);
  }

  // ---------------------------------------------------------------------------
  // User id
  // ---------------------------------------------------------------------------
  static Future<void> setUserId(String userId) async {
    await _instance.setString(AppConstants.storageKeyUserId, userId);
  }

  static String? getUserId() => _instance.getString(AppConstants.storageKeyUserId);

  // ---------------------------------------------------------------------------
  // Onboarding completed flag
  // ---------------------------------------------------------------------------
  static Future<void> setOnboardingCompleted(bool value) async {
    await _instance.setBool(AppConstants.storageKeyOnboardingCompleted, value);
  }

  static bool getOnboardingCompleted() =>
      _instance.getBool(AppConstants.storageKeyOnboardingCompleted) ?? false;

  // ---------------------------------------------------------------------------
  // Recently viewed product IDs (JSON string list)
  // ---------------------------------------------------------------------------
  static Future<void> setRecentlyViewed(List<String> ids) async {
    await _instance.setStringList(
      AppConstants.storageKeyRecentlyViewed,
      ids,
    );
  }

  static List<String> getRecentlyViewed() =>
      _instance.getStringList(AppConstants.storageKeyRecentlyViewed) ?? <String>[];

  // ---------------------------------------------------------------------------
  // Wishlist product IDs
  // ---------------------------------------------------------------------------
  static Future<void> setWishlist(List<String> ids) async {
    await _instance.setStringList(
      AppConstants.storageKeyWishlist,
      ids,
    );
  }

  static List<String> getWishlist() =>
      _instance.getStringList(AppConstants.storageKeyWishlist) ?? <String>[];
}