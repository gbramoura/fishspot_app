import 'package:fishspot_app/constants/route_constants.dart';
import 'package:fishspot_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class NavigationService {
  static void pushNamed(dynamic context, String route) async {
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

  static void popUntil(dynamic context, List<String> pages) async {
    if (!await AuthService.isUserAuthenticated(context)) {
      AuthService.clearCredentials(context);
      AuthService.showAuthDialog(context);
    }

    await AuthService.refreshCredentials(context);

    Navigator.of(context).popUntil((route) {
      return pages.contains(route.settings.name);
    });
  }

  static void push(dynamic context, Route route) async {
    if (!await AuthService.isUserAuthenticated(context)) {
      AuthService.clearCredentials(context);
      AuthService.showAuthDialog(context);
    }

    await AuthService.refreshCredentials(context);

    Navigator.push(context, route);
  }

  static void logout(dynamic context) {
    AuthService.clearCredentials(context);
    Navigator.pushNamed(context, RouteConstants.login);
  }
}
