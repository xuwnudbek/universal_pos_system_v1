import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:universal_pos_system_v1/data/local/app_database.dart';

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
  static const String _keyLastLogin = 'last_login';

  // Save user session
  static Future<bool> saveUserSession(User user) async {
    try {
      await setInt(_keyUserId, user.id);
      await setString(_keyUsername, user.username);
      await setString(_keyFullName, user.fullName);
      await setString(_keyUserRole, user.role.name);
      await setBool(_keyIsAuthenticated, true);
      await setString(_keyLastLogin, DateTime.now().toIso8601String());

      return true;
    } catch (e) {
      return false;
    }
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
      'lastLogin': getLastLogin()?.toIso8601String(),
    };
  }

  // Logout (clear auth data)
  static Future<bool> logout() async {
    await remove(_keyUserId);
    await remove(_keyUsername);
    await remove(_keyFullName);
    await remove(_keyUserRole);
    await remove(_keyIsAuthenticated);
    await remove(_keyLastLogin);
    return true;
  }

  // ========== App Settings Methods ==========

  static const String _keyFirstLaunch = 'first_launch';

  // First launch
  static Future<bool> setFirstLaunch(bool value) async {
    return await setBool(_keyFirstLaunch, value);
  }

  static bool isFirstLaunch() {
    return getBool(_keyFirstLaunch) ?? true;
  }
}
