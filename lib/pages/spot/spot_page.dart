import 'package:flutter/material.dart';

class SpotPage extends StatelessWidget {
  const SpotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 86),
        child: Text('FishSpot'),
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
