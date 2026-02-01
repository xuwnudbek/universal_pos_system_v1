import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorage {
  static SharedPreferences? _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw Exception('LocalStorage not initialized. Call LocalStorage.init() first.');
    }
    return _prefs!;
  }

  // ========== Basic Methods ==========

  // Save String
  static Future<bool> setString(String key, String value) async {
    return await _instance.setString(key, value);
  }

  // Get String
  static String? getString(String key) {
    return _instance.getString(key);
  }

  // Save Int
  static Future<bool> setInt(String key, int value) async {
    return await _instance.setInt(key, value);
  }

  // Get Int
  static int? getInt(String key) {
    return _instance.getInt(key);
  }

  // Save Double
  static Future<bool> setDouble(String key, double value) async {
    return await _instance.setDouble(key, value);
  }

  // Get Double
  static double? getDouble(String key) {
    return _instance.getDouble(key);
  }

  // Save Bool
  static Future<bool> setBool(String key, bool value) async {
    return await _instance.setBool(key, value);
  }

  // Get Bool
  static bool? getBool(String key) {
    return _instance.getBool(key);
  }

  // Save List of Strings
  static Future<bool> setStringList(String key, List<String> value) async {
    return await _instance.setStringList(key, value);
  }

  // Get List of Strings
  static List<String>? getStringList(String key) {
    return _instance.getStringList(key);
  }

  // Save Object as JSON
  static Future<bool> setObject(String key, Map<String, dynamic> value) async {
    final jsonString = jsonEncode(value);
    return await setString(key, jsonString);
  }

  // Get Object from JSON
  static Map<String, dynamic>? getObject(String key) {
    final jsonString = getString(key);
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  // Remove specific key
  static Future<bool> remove(String key) async {
    return await _instance.remove(key);
  }

  // Clear all data
  static Future<bool> clear() async {
    return await _instance.clear();
  }

  // Check if key exists
  static bool containsKey(String key) {
    return _instance.containsKey(key);
  }

  // Get all keys
  static Set<String> getAllKeys() {
    return _instance.getKeys();
  }

  // ========== Auth-Specific Methods ==========

  static const String _keyUserId = 'user_id';
  static const String _keyUsername = 'username';
  static const String _keyFullName = 'full_name';
  static const String _keyUserRole = 'user_role';
  static const String _keyIsAuthenticated = 'is_authenticated';
  static const String _keyAuthToken = 'auth_token';
  static const String _keyLastLogin = 'last_login';

  // Save user session
  static Future<bool> saveUserSession({
    required int userId,
    required String username,
    required String fullName,
    required String role,
    String? authToken,
  }) async {
    await setInt(_keyUserId, userId);
    await setString(_keyUsername, username);
    await setString(_keyFullName, fullName);
    await setString(_keyUserRole, role);
    await setBool(_keyIsAuthenticated, true);
    await setString(_keyLastLogin, DateTime.now().toIso8601String());

    if (authToken != null) {
      await setString(_keyAuthToken, authToken);
    }

    return true;
  }

  // Get user ID
  static int? getUserId() {
    return getInt(_keyUserId);
  }

  // Get username
  static String? getUsername() {
    return getString(_keyUsername);
  }

  // Get full name
  static String? getFullName() {
    return getString(_keyFullName);
  }

  // Get user role
  static String? getUserRole() {
    return getString(_keyUserRole);
  }

  // Get auth token
  static String? getAuthToken() {
    return getString(_keyAuthToken);
  }

  // Get last login time
  static DateTime? getLastLogin() {
    final lastLogin = getString(_keyLastLogin);
    if (lastLogin == null) return null;
    try {
      return DateTime.parse(lastLogin);
    } catch (e) {
      return null;
    }
  }

  // Check if user is authenticated
  static bool isAuthenticated() {
    return getBool(_keyIsAuthenticated) ?? false;
  }

  // Get complete user session
  static Map<String, dynamic>? getUserSession() {
    if (!isAuthenticated()) return null;

    return {
      'userId': getUserId(),
      'username': getUsername(),
      'fullName': getFullName(),
      'role': getUserRole(),
      'authToken': getAuthToken(),
      'lastLogin': getLastLogin()?.toIso8601String(),
    };
  }

  // Logout (clear auth data)
  static Future<bool> logout() async {
    await remove(_keyUserId);
    await remove(_keyUsername);
    await remove(_keyFullName);
    await remove(_keyUserRole);
    await remove(_keyAuthToken);
    await remove(_keyIsAuthenticated);
    await remove(_keyLastLogin);
    return true;
  }

  // ========== App Settings Methods ==========

  static const String _keyThemeMode = 'theme_mode';
  static const String _keyLanguage = 'language';
  static const String _keyFirstLaunch = 'first_launch';

  // Theme mode
  static Future<bool> setThemeMode(String mode) async {
    return await setString(_keyThemeMode, mode);
  }

  static String? getThemeMode() {
    return getString(_keyThemeMode);
  }

  // Language
  static Future<bool> setLanguage(String language) async {
    return await setString(_keyLanguage, language);
  }

  static String? getLanguage() {
    return getString(_keyLanguage);
  }

  // First launch
  static Future<bool> setFirstLaunch(bool value) async {
    return await setBool(_keyFirstLaunch, value);
  }

  static bool isFirstLaunch() {
    return getBool(_keyFirstLaunch) ?? true;
  }

  // ========== Cache Management ==========

  // Save with expiration time
  static Future<bool> setWithExpiry(String key, String value, Duration expiry) async {
    final expiryTime = DateTime.now().add(expiry).millisecondsSinceEpoch;
    await setString('${key}_expiry', expiryTime.toString());
    return await setString(key, value);
  }

  // Get with expiration check
  static String? getWithExpiry(String key) {
    final expiryString = getString('${key}_expiry');
    if (expiryString == null) return null;

    final expiryTime = int.tryParse(expiryString);
    if (expiryTime == null) return null;

    if (DateTime.now().millisecondsSinceEpoch > expiryTime) {
      // Expired, remove the data
      remove(key);
      remove('${key}_expiry');
      return null;
    }

    return getString(key);
  }

  // Clear expired cache
  static Future<void> clearExpiredCache() async {
    final keys = getAllKeys();
    for (final key in keys) {
      if (key.endsWith('_expiry')) {
        final dataKey = key.replaceAll('_expiry', '');
        getWithExpiry(dataKey); // This will remove expired data
      }
    }
  }
}
