import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  // Cached instance — initialised once, reused everywhere
  static SharedPreferences? _prefs;

  /// Call once at app startup (in main()) to warm the cache.
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<SharedPreferences> _instance() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  static Future<String> getString(String key) async {
    final prefs = await _instance();
    return prefs.getString(key) ?? '';
  }

  // Synchronous read — only safe after init() has completed
  static String getStringSync(String key) {
    return _prefs?.getString(key) ?? '';
  }

  static Future<bool> getBool(String key) async {
    final prefs = await _instance();
    return prefs.getBool(key) ?? false;
  }

  static bool getBoolSync(String key) {
    return _prefs?.getBool(key) ?? false;
  }

  static Future setString(String key, value) async {
    final prefs = await _instance();
    await prefs.setString(key, value.toString());
  }

  static Future setBool(String key, bool value) async {
    final prefs = await _instance();
    await prefs.setBool(key, value);
  }

  static Future setInt(String key, int value) async {
    final prefs = await _instance();
    await prefs.setInt(key, value);
  }

  static Future<int> getInt(String key) async {
    final prefs = await _instance();
    return prefs.getInt(key) ?? -1;
  }

  static int getIntSync(String key) {
    return _prefs?.getInt(key) ?? -1;
  }

  static Future remove(String key) async {
    final prefs = await _instance();
    return prefs.remove(key);
  }
}


