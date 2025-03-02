import 'package:fishspot_app/components/custom_bottom_navigation_bar.dart';
import 'package:fishspot_app/pages/map/map_page.dart';
import 'package:fishspot_app/pages/profile/profile_page.dart';
import 'package:fishspot_app/pages/spot/spot_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  List<Widget> body = const [
    MapPage(),
    SpotPage(),
    ProfilePage(),
  ];

  handleOnTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: body[currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        onTap: handleOnTap,
        currentIndex: currentIndex,
      ),
    );
  }
}
