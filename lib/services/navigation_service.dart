import 'package:fishspot_app/constants/route_constants.dart';
import 'package:fishspot_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class NavigationService {
  late AuthService _authService;

  NavigationService() {
    _authService = AuthService();
  }

  Future<T?> pushNamed<T>(dynamic context, String route) async {
    if (!await _authService.isUserAuthenticated(context)) {
      _authService.clearCredentials(context);
      _authService.showAuthDialog(context);
    }

    await _authService.refreshCredentials(context);

    return Navigator.pushNamed(context, route);
  }

  void pop<T>(dynamic context, {T? result}) async {
    if (!await _authService.isUserAuthenticated(context)) {
      _authService.clearCredentials(context);
      _authService.showAuthDialog(context);
    }

    await _authService.refreshCredentials(context);

    Navigator.pop(context, result);
  }

  void popUntil(dynamic context, List<String> pages) async {
    if (!await _authService.isUserAuthenticated(context)) {
      _authService.clearCredentials(context);
      _authService.showAuthDialog(context);
    }

    await _authService.refreshCredentials(context);

    Navigator.of(context).popUntil((route) {
      return pages.contains(route.settings.name);
    });
  }

  Future<T?> push<T>(dynamic context, Route<T> route) async {
    if (!await _authService.isUserAuthenticated(context)) {
      _authService.clearCredentials(context);
      _authService.showAuthDialog(context);
    }

    await _authService.refreshCredentials(context);

    return Navigator.push(context, route);
  }

  void logout(dynamic context) {
    _authService.clearCredentials(context);
    Navigator.pushNamed(context, RouteConstants.login);
  }
}
