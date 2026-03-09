import 'package:care_link_pro/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesHelper {
  // ------------------------
  // String Helpers
  // ------------------------
  static Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // ------------------------
  // Int Helpers
  // ------------------------
  static Future<void> saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }


  static Future<User?> getSavedUser() async {
  final prefs = await SharedPreferences.getInstance();

  String? userString = prefs.getString('user_object');

  print("Saved User Raw: $userString");

  if (userString == null || userString.isEmpty) {
    print("❌ No user found in SharedPreferences");
    return null;
  }

  final decoded = jsonDecode(userString);

  if (decoded == null) {
    print("❌ Decoded JSON is null");
    return null;
  }

  return User.fromJson(decoded as Map<String, dynamic>);
}

  // ------------------------
  // Delete / Clear
  // ------------------------
  static Future<void> deleteString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
