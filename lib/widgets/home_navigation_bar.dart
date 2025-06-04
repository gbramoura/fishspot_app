import 'package:flutter/material.dart';

class HomeNavigationBar extends StatelessWidget {
  final Function(int)? onTap;
  final int currentIndex;

  const HomeNavigationBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BottomNavigationBar(
        elevation: 1,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        onTap: onTap,
        iconSize: 42,
        selectedItemColor: Theme.of(context).textTheme.headlineLarge?.color,
        unselectedItemColor: Theme.of(context).textTheme.headlineLarge?.color,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: 'add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'person',
          ),
        ],
      ),
    );
  }
}
