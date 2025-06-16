import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveColor(String key, Color color) async {
    await _prefs.setInt(key, color.value);
  }

  static Color? getColor(String key) {
    final value = _prefs.getInt(key);
    return value != null ? Color(value) : null;
  }

  static Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static Future<void> saveDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
