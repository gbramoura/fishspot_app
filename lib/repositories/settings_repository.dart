import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingRepository extends ChangeNotifier {
  SharedPreferences prefs;

  SettingRepository({required this.prefs});

  String? getString(String key) {
    return prefs.getString(key);
  }

  bool? getBool(String key) {
    return prefs.getBool(key);
  }

  int? getInt(String key) {
    return prefs.getInt(key);
  }

  void setBool(String key, bool value) async {
    await prefs.setBool(key, value);
  }

  void setString(String key, String value) async {
    await prefs.setString(key, value);
  }

  void setInt(String key, int value) async {
    await prefs.setInt(key, value);
  }

  void clear() async {
    await prefs.clear();
  }
}
