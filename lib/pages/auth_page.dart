import 'package:fishspot_app/constants/route_constants.dart';
import 'package:fishspot_app/constants/shared_preferences_constants.dart';
import 'package:fishspot_app/providers/settings_repository.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _service = ApiService();

  @override
  initState() {
    super.initState();
    _validate();
  }

  Future<void> _validate() async {
    var settings = Provider.of<SettingRepository>(context, listen: false);

    try {
      String? token = settings.getString(SharedPreferencesConstants.jwtToken);

      if (token == null || token.isEmpty) {
        return _callNavigator(RouteConstants.login);
      }

      await _service.isAuth(token ?? '');

      if (mounted) {
        _callNavigator(RouteConstants.home);
      }
    } catch (e) {
      if (mounted) {
        _callNavigator(RouteConstants.login);
      }
    }
  }

  _callNavigator(String route) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(context, route);
    });
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
