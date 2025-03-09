import 'package:flutter/material.dart';

class SpotPage extends StatelessWidget {
  const SpotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Text(
          'FishSpot',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.headlineLarge?.color,
            fontSize: 22,
          ),
        ),
      ),
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
}
