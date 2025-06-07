import 'package:fishspot_app/constants/route_constants.dart';
import 'package:fishspot_app/pages/commons/empty_page.dart';
import 'package:fishspot_app/pages/commons/loading_page.dart';
import 'package:fishspot_app/pages/map/map_page.dart';
import 'package:fishspot_app/pages/profile/profile_page.dart';
import 'package:fishspot_app/providers/visible_control_provider.dart';
import 'package:fishspot_app/services/auth_service.dart';
import 'package:fishspot_app/services/navigation_service.dart';
import 'package:fishspot_app/widgets/home_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NavigationService _navigationService = NavigationService();
  final AuthService _authService = AuthService();

  int _currentIndex = 0;
  int _lastIndex = 0;
  bool _loading = false;

  final List<Widget> _body = <Widget>[
    MapPage(),
    EmptyPage(),
    ProfilePage(),
  ];

  Future<void> _handleNavigatePage(int index) async {
    setState(() {
      _loading = true;
    });

    if (!await _authService.isUserAuthenticated(context)) {
      if (mounted) {
        _authService.clearCredentials(context);
        _authService.showAuthDialog(context);
      }
    }

    if (mounted) {
      await _authService.refreshCredentials(context);
    }

    if (index == 1 && mounted) {
      _navigationService.pushNamed(context, RouteConstants.addSpot).then(
        (value) {
          setState(() {
            _currentIndex = _lastIndex;
            _loading = false;
          });
        },
      );
    }

    setState(() {
      _lastIndex = _currentIndex;
      _currentIndex = index;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext buildContext) {
    return Consumer<VisibleControlProvider>(
      builder: (context, value, widget) {
        return Scaffold(
          extendBody: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: _loading ? LoadingPage() : _body[_currentIndex],
          bottomNavigationBar: SizedBox(
            height: value.isBottomNavigationVisible() ? 100 : 0,
            child: HomeNavigationBar(
              onTap: _handleNavigatePage,
              currentIndex: _currentIndex,
            ),
          ),
        );
      },
    );
  }
}
