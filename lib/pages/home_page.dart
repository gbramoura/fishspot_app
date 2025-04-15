import 'package:fishspot_app/components/custom_bottom_navigation_bar.dart';
import 'package:fishspot_app/constants/route_constants.dart';
import 'package:fishspot_app/pages/loading_page.dart';
import 'package:fishspot_app/pages/map/map_page.dart';
import 'package:fishspot_app/pages/profile/profile_page.dart';
import 'package:fishspot_app/pages/spot/spot_page.dart';
import 'package:fishspot_app/services/auth_service.dart';
import 'package:fishspot_app/services/navigation_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool _loading = false;

  final List<Widget> _body = <Widget>[
    MapPage(),
    SpotPage(),
    ProfilePage(),
  ];

  Future<void> _handleNavigatePage(int index) async {
    if (index == 1) {
      NavigationService.pushNamed(context, RouteConstants.addSpot);
      return;
    }

    setState(() {
      _loading = true;
    });

    if (!await AuthService.isUserAuthenticated(context)) {
      if (mounted) {
        AuthService.clearCredentials(context);
        AuthService.showAuthDialog(context);
      }
    }

    if (mounted) {
      await AuthService.refreshCredentials(context);
    }

    setState(() {
      _currentIndex = index;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _loading ? LoadingPage() : _body[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        onTap: _handleNavigatePage,
        currentIndex: _currentIndex,
      ),
    );
  }
}
