# Trovemart Customer Application

Professional Nigerian e-commerce Flutter application for Trovemart — a single-retailer online store.

## Project Structure

Feature-based architecture (Section 31 of the specification):

```
lib/
  main.dart                 # Entry point — loads env, runs ProviderScope
  app/
    app.dart                # Root MaterialApp with theme and routing
  core/
    constants/
      app_constants.dart    # App-wide constants and storage keys
      env_config.dart       # Runtime environment configuration (.env)
    theme/
      app_theme.dart        # Light/dark theme data and colour tokens
    routing/
      app_router.dart       # Named routes and route generation
    network/
      api_client.dart       # Centralised Dio HTTP client
    storage/
      local_storage.dart    # SharedPreferences wrapper
    errors/
      app_exception.dart    # User-safe application exceptions
    utilities/
      logger.dart           # Structured logging (no secrets)
    shared_widgets/
      tm_button.dart        # Reusable button component
      tm_text_field.dart    # Reusable text field component
      tm_loading.dart       # Loading indicators
      tm_error_state.dart   # Error state display
      tm_offline_indicator.dart  # Offline connectivity indicator
      tm_product_card.dart        # Hybrid commercial product card (Section 8)
      tm_category_card.dart   # Visual category card (Section 11)
    app/
      app.dart                # Root MaterialApp with theme, AppShell routing
      navigation_shell.dart   # 4-tab bottom nav with IndexedStack state preservation
    providers/
      theme_providers.dart  # Riverpod providers for theme state
  features/
    authentication/         # Registration, login, auth flows
      models/user.dart      # User model, AuthResult, AuthStatus
      services/auth_service.dart  # Auth service (mock)
      providers/auth_provider.dart  # Auth state notifier (Riverpod)
      screens/login_screen.dart
      screens/register_screen.dart
      screens/forgot_password_screen.dart
      screens/email_verification_screen.dart
    home/                   # Home screen and sections
      providers/home_provider.dart  # Home state + section arrangement
      screens/home_screen.dart  # Main home screen (9 sections)
      widgets/home_search_bar.dart
      widgets/home_category_section.dart
      widgets/home_product_section.dart
    categories/             # Category browsing
    products/               # Product details and cards
    search/                 # Search and image search
    cart/                   # Shopping cart
    checkout/               # Checkout and Paystack payment
    orders/                 # Order history and tracking
    wishlist/               # Wishlist management
    account/                # Account dashboard
    addresses/              # Saved addresses
    notifications/          # Push and in-app notifications
    recently_viewed/        # Recently viewed products
      providers/recently_viewed_provider.dart  # Recently viewed notifier
    support/                # WhatsApp/telephone support
    settings/               # Settings and preferences
```

## Dependencies

| Package | Purpose |
|---|---|
| `flutter_riverpod: ^2.5.1` | State management (compile-time safe, no BuildContext required) |
| `dio: ^5.4.0` | HTTP client with interceptors and request/response logging |
| `cached_network_image: ^3.3.0` | Image caching and progressive loading |
| `shared_preferences: ^2.2.3` | Local storage for preferences and caching |
| `lucide_icons: ^0.360.0` | Lucide icons (outline by default, filled active states) |
| `connectivity_plus: ^6.0.0` | Network connectivity / offline detection |
| `shimmer: ^3.0.0` | Skeleton loading shimmer effects |
| `intl: ^0.19.0` | Internationalization support |
| `flutter_dotenv: ^5.1.0` | Environment configuration from `.env` files |

## Environment Setup

1. Copy `.env` to `.env.development`, `.env.testing`, `.env.production` as needed.
2. Set `API_BASE_URL` to the backend API URL supplied by the backend team.
3. Never commit production secrets to version control.

## Development Phases

Per Section 37 of the specification, development proceeds in controlled phases:

1. ✅ Phase 1: Project inspection and setup (complete)
2. ✅ Phase 2: Design system and reusable components (complete)
3. ✅ Phase 3: Splash, onboarding and navigation (complete)
4. ✅ Phase 4: Authentication (complete)
5. ✅ Phase 5: Home screen (complete)
6. Phase 6: Categories and product details
7. Phase 7: Search and image search
8. Phase 8: Wishlist and recently viewed
9. Phase 9: Cart
10. Phase 10: Checkout and payment
11. Phase 11: Orders and tracking
12. Phase 12: Notifications
13. Phase 13: Addresses and delivery
14. Phase 14: Support, privacy and settings
15. Phase 15: Offline support and performance
16. Phase 16: Comprehensive testing and release preparation

## Backend Dependencies

The following require backend API contracts before implementation:
- Authentication endpoints (register, login, Google sign-in, forgot password)
- Product catalog endpoints
- Cart endpoints
- Checkout and Paystack integration
- Order and tracking endpoints
- Address endpoints
- Notification endpoints

## Testing

Run `flutter test` to execute unit and widget tests.
Run `flutter analyze` for static analysis.

## Version

Current version: 1.0.0+1 (semantic versioning)
