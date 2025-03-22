import 'package:fishspot_app/constants/route_constants.dart';
import 'package:fishspot_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class NavigationService {
  static void push(dynamic context, String route) async {
    if (!await AuthService.isUserAuthenticated(context)) {
      AuthService.clearCredentials(context);
      AuthService.showAuthDialog(context);
    }

    await AuthService.refreshCredentials(context);

    Navigator.pushNamed(context, route);
  }

  static void pop(dynamic context) async {
    if (!await AuthService.isUserAuthenticated(context)) {
      AuthService.clearCredentials(context);
      AuthService.showAuthDialog(context);
    }

    await AuthService.refreshCredentials(context);

    Navigator.pop(context);
  }

  static void logout(dynamic context) {
    AuthService.clearCredentials(context);
    Navigator.pushNamed(context, RouteConstants.login);
  }
}
