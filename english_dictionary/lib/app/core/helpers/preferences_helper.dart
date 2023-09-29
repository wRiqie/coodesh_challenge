import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  SharedPreferences? _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  String? getString(String key) {
    return _preferences!.getString(key);
  }

  bool getBool(String key) {
    return _preferences!.getBool(key) ?? false;
  }

  Future<bool> setString(String key, String value) {
    return _preferences!.setString(key, value);
  }

  Future<bool> setBool(String key, bool value) {
    return _preferences!.setBool(key, value);
  }

  Future<bool> remove(String key) {
    return _preferences!.remove(key);
  }
}
