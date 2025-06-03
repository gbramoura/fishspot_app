import 'package:flutter/material.dart';

class VisibleControlProvider extends ChangeNotifier {
  bool _isBotttomNavigationVisible = true;
  bool _isAppBarVisible = true;

  bool isBottomNavigationVisible() => _isBotttomNavigationVisible;

  bool isAppBarVisible() => _isAppBarVisible;

  void setVisible(bool value) {
    _isBotttomNavigationVisible = value;
    notifyListeners();
  }

  void setAppBarVisible(bool value) {
    _isAppBarVisible = value;
    notifyListeners();
  }

  void clear() {
    _isAppBarVisible = true;
    _isBotttomNavigationVisible = true;
  }
}
