import 'package:shared_preferences/shared_preferences.dart';


class SharedPreferencesHelper {
  static Future<bool> saveString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool> deleteString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }
}