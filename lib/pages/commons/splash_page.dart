import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

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
