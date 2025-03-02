import 'package:fishspot_app/constants/route_constants.dart';
import 'package:fishspot_app/pages/home_page.dart';
import 'package:fishspot_app/pages/login_page.dart';
import 'package:fishspot_app/pages/password/recover_password_page.dart';
import 'package:fishspot_app/pages/register_page.dart';
import 'package:fishspot_app/pages/splash_page.dart';
import 'package:fishspot_app/repositories/settings_repository.dart';
import 'package:fishspot_app/theme/dark_theme.dart';
import 'package:fishspot_app/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(ChangeNotifierProvider(
    create: (context) => SettingRepository(prefs: prefs),
    child: const BuildingApp(),
  ));

  // TODO: Loadin the stuff here
  Future.delayed(Duration(seconds: 5), () {});

  // TODO: Authenticate and place the correct route
  Future.delayed(Duration(seconds: 10), () {});

  runApp(ChangeNotifierProvider(
    create: (context) => SettingRepository(prefs: prefs),
    child: const App(),
  ));
}

class BuildingApp extends StatelessWidget {
  const BuildingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FishSpot',
      debugShowCheckedModeBanner: false,
      theme: lighMode,
      darkTheme: darkMode,
      home: const SplashPage(),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

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
        RouteConstants.home: (context) => HomePage(),
      },
    );
  }
}
