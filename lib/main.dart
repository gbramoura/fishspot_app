import 'package:fishspot_app/constants/route_constants.dart';
import 'package:fishspot_app/pages/login_page.dart';
import 'package:fishspot_app/pages/password/recover_password_page.dart';
import 'package:fishspot_app/pages/register_page.dart';
import 'package:fishspot_app/theme/dark_theme.dart';
import 'package:fishspot_app/theme/light_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FishSpot',
      debugShowCheckedModeBanner: false,
      theme: lighMode,
      darkTheme: darkMode,
      home: LoginPage(),
      routes: {
        RouteConstants.login: (context) => const LoginPage(),
        RouteConstants.register: (context) => const RegisterPage(),
        RouteConstants.recoverPassword: (context) => RecoverPasswordPage(),
      },
    );
  }
}
