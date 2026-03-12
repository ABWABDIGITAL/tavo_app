// lib/core/helpers/shared_pref_helper.dart


import 'package:shared_preferences/shared_preferences.dart';
import 'package:tavo/core/SharedPreferences%20Helper/shared_pref_keys.dart';

class SharedPrefHelper {
  SharedPrefHelper._();

  static SharedPreferences? _preferences;


  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }


  static SharedPreferences get instance {
    if (_preferences == null) {
      throw Exception('SharedPrefHelper not initialized. Call init() first.');
    }
    return _preferences!;
  }




  static Future<bool> setString(String key, String value) async {
    return await instance.setString(key, value);
  }


  static String? getString(String key) {
    return instance.getString(key);
  }


  static String getStringWithDefault(String key, {String defaultValue = ''}) {
    return instance.getString(key) ?? defaultValue;
  }


  static Future<bool> setInt(String key, int value) async {
    return await instance.setInt(key, value);
  }


  static int? getInt(String key) {
    return instance.getInt(key);
  }


  static int getIntWithDefault(String key, {int defaultValue = 0}) {
    return instance.getInt(key) ?? defaultValue;
  }




  static Future<bool> setDouble(String key, double value) async {
    return await instance.setDouble(key, value);
  }


  static double? getDouble(String key) {
    return instance.getDouble(key);
  }


  static double getDoubleWithDefault(String key, {double defaultValue = 0.0}) {
    return instance.getDouble(key) ?? defaultValue;
  }


  static Future<bool> setBool(String key, bool value) async {
    return await instance.setBool(key, value);
  }


  static bool? getBool(String key) {
    return instance.getBool(key);
  }


  static bool getBoolWithDefault(String key, {bool defaultValue = false}) {
    return instance.getBool(key) ?? defaultValue;
  }


  static Future<bool> setStringList(String key, List<String> value) async {
    return await instance.setStringList(key, value);
  }


  static List<String>? getStringList(String key) {
    return instance.getStringList(key);
  }


  static List<String> getStringListWithDefault(String key) {
    return instance.getStringList(key) ?? [];
  }


  static Future<bool> setData(String key, dynamic value) async {
    if (value is String) {
      return await setString(key, value);
    } else if (value is int) {
      return await setInt(key, value);
    } else if (value is double) {
      return await setDouble(key, value);
    } else if (value is bool) {
      return await setBool(key, value);
    } else if (value is List<String>) {
      return await setStringList(key, value);
    }
    throw Exception('Unsupported type: ${value.runtimeType}');
  }


  static dynamic getData(String key) {
    return instance.get(key);
  }


  static Future<bool> removeData(String key) async {
    return await instance.remove(key);
  }


  static bool containsKey(String key) {
    return instance.containsKey(key);
  }


  static Future<bool> clearAllData() async {
    return await instance.clear();
  }

  static Future<void> clearUserData() async {
    await removeData(SharedPrefKeys.userToken);
    await removeData(SharedPrefKeys.refreshToken);
    await removeData(SharedPrefKeys.userId);
    await removeData(SharedPrefKeys.userName);
    await removeData(SharedPrefKeys.userEmail);
    await removeData(SharedPrefKeys.userPhone);
    await removeData(SharedPrefKeys.userImage);
    await removeData(SharedPrefKeys.isLoggedIn);
    await removeData(SharedPrefKeys.cartId);
    await removeData(SharedPrefKeys.cartItemsCount);
    await removeData(SharedPrefKeys.defaultAddressId);
  }


  static Future<void> saveLoginData({
    required String token,
    String? refreshToken,
    required int userId,
    required String userName,
    String? userEmail,
    String? userPhone,
    String? userImage,
  }) async {
    await setString(SharedPrefKeys.userToken, token);
    if (refreshToken != null) {
      await setString(SharedPrefKeys.refreshToken, refreshToken);
    }
    await setInt(SharedPrefKeys.userId, userId);
    await setString(SharedPrefKeys.userName, userName);
    if (userEmail != null) {
      await setString(SharedPrefKeys.userEmail, userEmail);
    }
    if (userPhone != null) {
      await setString(SharedPrefKeys.userPhone, userPhone);
    }
    if (userImage != null) {
      await setString(SharedPrefKeys.userImage, userImage);
    }
    await setBool(SharedPrefKeys.isLoggedIn, true);
  }


  static String? getToken() {
    return getString(SharedPrefKeys.userToken);
  }


  static bool isLoggedIn() {
    return getBoolWithDefault(SharedPrefKeys.isLoggedIn, defaultValue: false) &&
        getToken() != null;
  }


  static int? getUserId() {
    return getInt(SharedPrefKeys.userId);
  }


  static String? getUserName() {
    return getString(SharedPrefKeys.userName);
  }


  static bool isFirstTime() {
    return getBoolWithDefault(SharedPrefKeys.isFirstTime, defaultValue: true);
  }


  static Future<void> setNotFirstTime() async {
    await setBool(SharedPrefKeys.isFirstTime, false);
  }


  static String getLanguage() {
    return getStringWithDefault(SharedPrefKeys.language, defaultValue: 'en');
  }


  static Future<void> setLanguage(String langCode) async {
    await setString(SharedPrefKeys.language, langCode);
  }


  static bool isDarkMode() {
    return getBoolWithDefault(SharedPrefKeys.isDarkMode, defaultValue: false);
  }


  static Future<void> setDarkMode(bool value) async {
    await setBool(SharedPrefKeys.isDarkMode, value);
  }
}