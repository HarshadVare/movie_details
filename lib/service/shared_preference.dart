import 'dart:convert';

import 'package:movie_details/models/cached_repsonse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static CacheManager? _instance;

  factory CacheManager() {
    _instance ??= CacheManager._();
    return _instance!;
  }

  CacheManager._();

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

  // Save data to cache with an expiration time of 24 hours
  Future<void> saveCache(String key, String data) async {
    final res = CachedResponse(
      data: data,
      expiresAt: DateTime.now().add(
        const Duration(hours: 24),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, json.encode(CachedResponse.toJson(res)));
  }

  // Retrieve valid cache if it exists and has not expired
  Future<(bool, CachedResponse?)> getValidCache(String key) async {
    final prefs = await SharedPreferences.getInstance();

    // Check if the cache exists
    if (!prefs.containsKey(key)) return (false, null);

    // Get the cached data
    final cached = prefs.getString(key);

    // Check if the cache is empty
    if (cached == null) return (false, null);

    // Parse the cached data
    final parsed = CachedResponse.fromJson(jsonDecode(cached));

    // Check if the cache has expired
    if (parsed.expiresAt.isAfter(DateTime.now())) {
      return (true, parsed);
    } else {
      return (false, null);
    }
  }
}
