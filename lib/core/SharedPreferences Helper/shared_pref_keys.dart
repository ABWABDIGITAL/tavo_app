// lib/core/helpers/shared_pref_keys.dart

class SharedPrefKeys {
  SharedPrefKeys._();

  // Auth Keys
  static const String userToken = 'user_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userName = 'user_name';
  static const String userEmail = 'user_email';
  static const String userPhone = 'user_phone';
  static const String userImage = 'user_image';
  static const String isLoggedIn = 'is_logged_in';

  // User Preferences
  static const String language = 'language';
  static const String isDarkMode = 'is_dark_mode';
  static const String isFirstTime = 'is_first_time';
  static const String notificationsEnabled = 'notifications_enabled';

  // Cart
  static const String cartId = 'cart_id';
  static const String cartItemsCount = 'cart_items_count';

  // Address
  static const String defaultAddressId = 'default_address_id';

  // FCM
  static const String fcmToken = 'fcm_token';

  // App Settings
  static const String currency = 'currency';
  static const String countryCode = 'country_code';
}