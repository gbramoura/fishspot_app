import 'package:fishspot_app/constants/route_constants.dart';
import 'package:fishspot_app/pages/auth_page.dart';
import 'package:fishspot_app/pages/commons/splash_page.dart';
import 'package:fishspot_app/pages/home_page.dart';
import 'package:fishspot_app/pages/login_page.dart';
import 'package:fishspot_app/pages/password/recover_password_page.dart';
import 'package:fishspot_app/pages/profile/profile_user_configuration_page.dart';
import 'package:fishspot_app/pages/profile/profile_user_edit_page.dart';
import 'package:fishspot_app/pages/register_page.dart';
import 'package:fishspot_app/pages/spot/spot_page.dart';
import 'package:fishspot_app/repositories/settings_repository.dart';
import 'package:fishspot_app/theme/dark_theme.dart';
import 'package:fishspot_app/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(ChangeNotifierProvider(
    create: (context) => SettingRepository(prefs: prefs),
    child: const BuildingApp(),
  ));

  await dotenv.load(fileName: '.env');

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
      home: AuthPage(),
      routes: {
        RouteConstants.login: (context) => LoginPage(),
        RouteConstants.register: (context) => RegisterPage(),
        RouteConstants.recoverPassword: (context) => RecoverPasswordPage(),
        RouteConstants.home: (context) => HomePage(),
        RouteConstants.configuration: (context) =>
            ProfileUserConfigurationPage(),
        RouteConstants.editUser: (context) => ProfileUserEditPage(),
        RouteConstants.addSpot: (context) => SpotPage()
      },
    );
  }
}
