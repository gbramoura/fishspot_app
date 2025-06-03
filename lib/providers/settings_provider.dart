import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider extends ChangeNotifier {
  final SharedPreferences prefs;

  SettingProvider({
    required this.prefs,
  });

  String? getString(String key) => prefs.getString(key);

  bool? getBool(String key) => prefs.getBool(key);

  int? getInt(String key) => prefs.getInt(key);

  void setBool(String key, bool value) async {
    await prefs.setBool(key, value);
    notifyListeners();
  }

  void setString(String key, String value) async {
    await prefs.setString(key, value);
    notifyListeners();
  }

  void setInt(String key, int value) async {
    await prefs.setInt(key, value);
    notifyListeners();
  }

  void clear() async {
    await prefs.clear();
  }
}
