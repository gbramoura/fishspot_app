import 'package:fishspot_app/widgets/button.dart';
import 'package:fishspot_app/pages/commons/loading_page.dart';
import 'package:fishspot_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileUserConfigurationPage extends StatefulWidget {
  const ProfileUserConfigurationPage({super.key});

  @override
  State<ProfileUserConfigurationPage> createState() =>
      _ProfileUserConfigurationPageState();
}

class _ProfileUserConfigurationPageState
    extends State<ProfileUserConfigurationPage> {
  final NavigationService _navigationService = NavigationService();

  bool _loading = false;
  String _version = '0.0.0';

  @override
  void initState() {
    super.initState();
    _loadAppData();
  }

  _loadAppData() async {
    setState(() {
      _loading = true;
    });

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;

    setState(() {
      _loading = false;
    });
  }

  _handleLogout() {
    _navigationService.logout(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return LoadingPage();
    }

    return Scaffold(
      appBar: _renderAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              height: 150,
              width: 150,
              image: AssetImage('assets/fish-spot-icon.png'),
            ),
            Text(
              'Aplicação FishSpot',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.headlineLarge?.color,
                fontSize: 18,
              ),
            ),
            Text(
              'v$_version',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.headlineLarge?.color,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 50),
            Button(
              label: 'Encerrar Sessão',
              onPressed: _handleLogout,
              fixedSize: Size(160, 48),
            )
          ],
        ),
      ),
    );
  }

  _renderAppBar(dynamic context) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: Colors.transparent,
      title: Row(
        children: [
          Text(
            'Configuração',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.headlineLarge?.color,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
