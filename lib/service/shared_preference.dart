import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static MySharedPreferences? _instance;

  factory MySharedPreferences() {
    _instance ??= MySharedPreferences._();
    return _instance!;
  }

  MySharedPreferences._();

  // Method to get a value from SharedPreferences
  Future<String?> get(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Method to save a value to SharedPreferences
  Future<void> put(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<bool> has(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  // Method to clear a value from SharedPreferences
  Future<void> remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
