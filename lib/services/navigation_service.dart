import 'package:fishspot_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class NavigationService {
  static void push(dynamic context, String route) async {
    if (!await AuthService.isUserAuthenticated(context)) {
      AuthService.clearUserCredentials(context);
      AuthService.showAuthDialog(context);
    }

    await AuthService.refreshUserCredentials(context);

    Navigator.pushNamed(context, route);
  }

  static void pop(dynamic context, String route) async {
    if (!await AuthService.isUserAuthenticated(context)) {
      AuthService.clearUserCredentials(context);
      AuthService.showAuthDialog(context);
    }

    await AuthService.refreshUserCredentials(context);

    Navigator.pop(context);
  }
}
