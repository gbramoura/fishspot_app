import 'package:fishspot_app/constants/route_constants.dart';
import 'package:fishspot_app/constants/shared_preferences_constants.dart';
import 'package:fishspot_app/repositories/settings_repository.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final apiService = ApiService();

  @override
  initState() {
    super.initState();
    validate();
  }

  Future<void> validate() async {
    var settings = Provider.of<SettingRepository>(context, listen: false);

    try {
      String? token = settings.getString(SharedPreferencesConstants.jwtToken);

      if (token == null || token.isEmpty) {
        Navigator.pushNamed(context, RouteConstants.login);
      }

      await apiService.isAuth(token ?? '');

      if (mounted) {
        Navigator.pushNamed(context, RouteConstants.home);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pushNamed(context, RouteConstants.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/fish-spot-icon.png',
                width: 175,
                height: 175,
              ),
              CircularProgressIndicator(
                color: Theme.of(context).textTheme.headlineLarge?.color,
              )
            ],
          ),
        ),
      ),
    );
  }
}
