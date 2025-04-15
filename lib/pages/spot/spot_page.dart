import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/pages/commons/loading_page.dart';
import 'package:fishspot_app/services/navigation_service.dart';
import 'package:flutter/material.dart';

class SpotPage extends StatefulWidget {
  const SpotPage({super.key});

  @override
  State<SpotPage> createState() => _SpotPageState();
}

class _SpotPageState extends State<SpotPage> {
  bool _loading = false;

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
          children: [
            Text(
              'Spot Page',
              style: TextStyle(fontSize: 48),
            ),
          ],
        ),
      ),
    );
  }

  _renderAppBar(dynamic context) {
    return AppBar(
      shadowColor: ColorsConstants.gray350,
      leading: IconButton(
        icon: Icon(
          Icons.close_rounded,
          color: Theme.of(context).textTheme.headlineLarge?.color,
          size: 32,
        ),
        onPressed: () {
          NavigationService.pop(context);
        },
      ),
      title: Row(
        children: [
          Text(
            'Local de Pesca',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.headlineLarge?.color,
              fontSize: 18,
            ),
          ),
        ],
      ),
      actions: [
        // TODO: Make the search page works
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
          color: Theme.of(context).textTheme.headlineLarge?.color,
          iconSize: 32,
        ),
        SizedBox(width: 10)
      ],
    );
  }
}
