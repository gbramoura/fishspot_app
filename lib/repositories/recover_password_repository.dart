import 'package:flutter/material.dart';

class RecoverPasswordRepository extends ChangeNotifier {
  String _email = "";
  String _token = "";

  String getEmail() => _email;

  String getToken() => _token;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setToken(String value) {
    _token = value;
    notifyListeners();
  }

  void clear() {
    _email = "";
    _token = "";
  }
}
